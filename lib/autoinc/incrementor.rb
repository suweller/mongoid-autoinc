module Mongoid

  module Autoinc

    class Incrementor
      attr_accessor :model_name, :field_name, :scope_key, :collection

      def initialize(model_name, field_name, scope_key=nil)
        self.model_name = model_name
        self.field_name = field_name.to_s
        self.scope_key = scope_key
        self.collection = ::Mongoid.default_session['auto_increment_counters']
      end

      def key
        "".tap do |str|
          str << "#{model_name.underscore}_#{field_name}"
          str << "_#{scope_key}" unless scope_key.blank?
        end
      end

      def inc
        collection.find(
          '_id' => key
        ).modify(
          {'$inc' => { 'c' => 1 }},
          :new => true, :upsert => true
        )['c']
      end

    end

  end

end
