module Mongoid
  module Autoinc
    class Incrementor
      attr_accessor(
        :model_name,
        :field_name,
        :scope_key,
        :collection,
        :seed,
        :step,
      )

      def initialize(model_name, field_name, options = {})
        self.model_name = model_name.to_s
        self.field_name = field_name.to_s
        self.scope_key = options.fetch(:scope, nil)
        self.step = options.fetch(:step, 1)
        self.seed = options.fetch(:seed, nil)
        self.collection = ::Mongoid.default_session['auto_increment_counters']
        create if seed && !exists?
      end

      def key
        return "#{model_name.underscore}_#{field_name}" if scope_key.blank?
        "#{model_name.underscore}_#{field_name}_#{scope_key}"
      end

      def inc
        find.modify({'$inc' => {c: step}}, new: true, upsert: true).fetch('c')
      end

      private

      def find
        collection.find(_id: key)
      end

      def create
        collection.insert(_id: key, c: seed)
      end

      def exists?
        find.count > 0
      end
    end
  end
end
