require 'incrementor'

module Mongoid

  module Autoinc
    extend ActiveSupport::Concern

    included do
      before_create :update_auto_increments
    end

    module ClassMethods

      def autoincrementing_fields
        @autoincrementing_fields ||= {}
      end

      def auto_increment(field, options={})
        autoincrementing_fields[field] = options

        attr_protected field
      end

    end

    module InstanceMethods

      def update_auto_increments
        self.class.autoincrementing_fields.each do |autoincrementing_field, options|
          scope_key = options[:scope] ? send(options[:scope]) : nil
          write_attribute(
            autoincrementing_field.to_sym,
            Mongoid::Autoinc::Incrementor.new(self.class.name, autoincrementing_field, scope_key).inc
          )
        end

      end

    end

  end

end
