# Based on http://ihswebdesign.com/blog/autoincrement-in-mongodb-with-ruby/
module Mongoid

  module Autoinc

    class Incrementor
      attr_accessor :model_name, :field_name, :collection

      def initialize(model_name, field_name)
        self.model_name = model_name
        self.field_name = field_name.to_s

        self.collection = Mongoid.database['auto_increment_counters']
      end

      def key
        "#{model_name.underscore}_#{field_name}"
      end

      def ensuring_document(&block)
        collection.insert('_id' => key, 'c' => 0) unless collection.count('_id' => key) > 0
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
