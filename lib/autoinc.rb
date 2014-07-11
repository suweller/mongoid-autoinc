require 'autoinc/incrementor'

module Mongoid
  module Autoinc
    extend ActiveSupport::Concern

    AlreadyAssignedError = Class.new(StandardError)
    AutoIncrementsError = Class.new(StandardError)

    included do
      before_create :update_auto_increments
    end

    module ClassMethods
      def incrementing_fields
        if superclass.respond_to?(:incrementing_fields)
          @incrementing_fields ||= superclass.incrementing_fields.dup
        else
          @incrementing_fields ||= {}
        end
      end

      def increments(field, options = {})
        incrementing_fields[field] = options.reverse_merge!(auto: true)
        attr_protected(field) if respond_to?(:attr_protected)
      end
    end

    def assign!(field)
      options = self.class.incrementing_fields[field]
      fail AutoIncrementsError if options[:auto]
      fail AlreadyAssignedError if send(field).present?
      increment!(field, options)
    end

    def update_auto_increments
      self.class.incrementing_fields.each do |field, options|
        increment!(field, options) if options[:auto]
      end
    end

    def increment!(field, options)
      options = options.dup
      model_name = (options.delete(:model_name) || self.class.model_name).to_s
      options[:scope] = evaluate_scope(options[:scope]) if options[:scope]
      options[:step] = evaluate_step(options[:step]) if options[:step]
      write_attribute(
          field.to_sym,
          Mongoid::Autoinc::Incrementor.new(model_name, field, options).inc
      )
    end

    def evaluate_scope(scope)
      return send(scope) if scope.is_a? Symbol
      return instance_exec(&scope) if scope.is_a? Proc
      fail 'scope is not a Symbol or a Proc'
    end

    def evaluate_step(step)
      return step if step.is_a? Integer
      return evaluate_step_proc(step) if step.is_a? Proc
      fail 'step is not an Integer or a Proc'
    end

    def evaluate_step_proc(step_proc)
      result = instance_exec(&step_proc)
      return result if result.is_a? Integer
      fail 'step Proc does not evaluate to an Integer'
    end
  end
end
