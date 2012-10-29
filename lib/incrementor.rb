# Based on http://ihswebdesign.com/blog/autoincrement-in-mongodb-with-ruby/

class AutoIncrementCounters
  include Mongoid::Document
  field :c, type: Integer 
end

module Mongoid

  module Autoinc

    class Incrementor
      attr_accessor :model_name, :field_name, :scope_key, :collection

      def initialize(model_name, field_name, scope_key=nil)
        self.model_name = model_name
        self.field_name = field_name.to_s
        self.scope_key = scope_key
        self.collection = AutoIncrementCounters.collection
      end

      def key
        "".tap do |str|
          str << "#{model_name.underscore}_#{field_name}"
          str << "_#{scope_key}" unless scope_key.blank?
        end
      end

      def ensuring_document(&block)
        collection.insert('_id' => key, 'c' => 0) unless collection.find(:_id => key).first
        yield
      end

      def inc
        ensuring_document do
          collection.find(:id => key).upsert('$inc' => { 'c' => 1 })
          collection.find(:id => key).first['c']
        end
      end

    end

  end

end
