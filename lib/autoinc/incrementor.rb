module Mongoid
  module Autoinc
    # Object which wraps the mongodb operations needed to allow for
    # autoincrementing fields in +Mongoid::Document+ models.
    class Incrementor
      # The name of the autoincrementing model.
      attr_reader(:model_name)

      # The name of the field of the autoincrementing model.
      attr_reader(:field_name)

      # The constraint, allowing for more then one series on the same
      # +model_name+ +field_name+ combination.
      attr_reader(:scope_key)

      # The mongo connection to the autoincrement counters collection.
      attr_reader(:collection)

      # The autoincrement offset.
      attr_reader(:seed)

      # How the next autoincrement number should be calculated.
      attr_reader(:step)

      # Creates a new incrementor object for the passed +field_name+
      #
      # @param [ String ] model_name Part of the name of the increment +key+
      # @param [ String ] field_name The name of the +field+ to increment
      # @param [ Hash ] options Options to pass to the incrementer
      #
      def initialize(model_name, field_name, options = {})
        @model_name = model_name.to_s
        @field_name = field_name.to_s
        @scope_key = options.fetch(:scope, nil)
        @step = options.fetch(:step, 1)
        @seed = options.fetch(:seed, nil)
        @collection = ::Mongoid.default_client['auto_increment_counters']
        create if @seed && !exists?
      end

      # Returns the increment key
      #
      # @return [ String ] The key to increment
      def key
        return "#{model_name.underscore}_#{field_name}" if scope_key.blank?
        "#{model_name.underscore}_#{field_name}_#{scope_key}"
      end

      # Increments the +value+ of the +key+ and returns it using an atomic op
      #
      # @return [ Integer ] The next value of the incrementor
      def inc
        find.find_one_and_update({'$inc' => {c: step}}, upsert: true, return_document: :after).fetch('c')
      end

      private

      # Find the incrementor document, using the +key+ id.
      #
      # @return [ Hash ] The persisted version of this incrementor.
      def find
        collection.find(_id: key)
      end

      # Persists the incrementor using +key+ as id and +seed+ as value of +c+.
      #
      def create
        collection.insert_one(_id: key, c: seed)
      end

      # Checks if the incrementor is persisted
      #
      # @return [ true, false ] If the incrementor is already persisted.
      def exists?
        find.count > 0
      end
    end
  end
end
