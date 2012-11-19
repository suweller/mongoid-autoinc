# Based on http://ihswebdesign.com/blog/autoincrement-in-mongodb-with-ruby/
module Mongoid

  module Autoinc

    class Incrementor
      attr_accessor :model_name, :field_name, :scope_key, :collection

      def initialize(model_name, field_name, scope_key=nil)
        self.model_name = model_name
        self.field_name = field_name.to_s
        self.scope_key = scope_key
      end

      def collection
        if ::Mongoid::VERSION < '3'
          Mongoid.database['auto_increment_counters']
        else
          ::Mongoid.default_session['auto_increment_counters']
        end
      end

      def key
        "".tap do |str|
          str << "#{model_name.underscore}_#{field_name}"
          str << "_#{scope_key}" unless scope_key.blank?
        end
      end

      def ensuring_document(&block)
        collection.insert('_id' => key, 'c' => 0) unless collection.find_one('_id' => key)
        yield
      end

      def inc
        ensuring_document do
          collection.find_and_modify(
            'query' => { '_id' => key },
            'update' => { '$inc' => { 'c' => 1 } },
            'new' => true
          )['c']
        end
      end

    end

  end

end
