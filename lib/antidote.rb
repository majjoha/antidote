require_relative "antidote/variable_type_error"
require_relative "antidote/return_type_error"

module Antidote
  class << self
    def included(klass)
      klass.extend(ClassMethods)
    end
  end

  module ClassMethods
    @@type_constraints = Hash.new { |h, k| h[k] = [] } 

    def annotate(*variables, return_type, &method_name)
      method_name = method_name.call.to_s
      add_type_constraints(method_name, variables, return_type)
      redefine_instance_method(method_name)
    end

    def annotate_class_method(*variables, return_type, &method_name)
      method_name = "self.#{method_name.call.to_s}"
      add_type_constraints(method_name, variables, return_type)
      redefine_class_method(method_name)
    end

    private

    def add_type_constraints(method_name, variables, return_type)
      variables.each { |variable| @@type_constraints[method_name] << variable }
      @@type_constraints[method_name] << {__returns: return_type}
    end

    def redefine_class_method(method_name)
      method_name = method_name.split(".").last
      new_name_for_old_method = "#{method_name}_old".to_sym
      self.singleton_class.send(:alias_method, new_name_for_old_method, method_name)

      define_singleton_method(method_name) do |*args|
        args.each_with_index do |argument, index|
          class_method = "self.#{method_name}"
          actual = argument.class
          expected = @@type_constraints[class_method][index]
          parameters = self.method(new_name_for_old_method).parameters.map(&:last)
          variable_name = parameters[index]
          @__return_type = @@type_constraints[class_method].last[:__returns]

          unless actual == expected
            raise VariableTypeError, [actual, expected, variable_name, class_method]
          end
        end

        if (klass = self.send(new_name_for_old_method, *args).class) != @__return_type 
          raise ReturnTypeError, [klass, @__return_type, class_method]
        else
          self.send(new_name_for_old_method, *args)
        end
      end
    end

    def redefine_instance_method(method_name)
      new_name_for_old_method = "#{method_name}_old".to_sym
      alias_method(new_name_for_old_method, method_name)

      define_method(method_name) do |*args|
        args.each_with_index do |argument, index|
          actual = argument.class
          expected = @@type_constraints[method_name][index]
          parameters = self.method(new_name_for_old_method).parameters.map(&:last)
          variable_name = parameters[index]
          @__return_type = @@type_constraints[method_name].last[:__returns]

          unless actual == expected
            raise VariableTypeError, [actual, expected, variable_name, method_name]
          end
        end

        if (klass = self.send(new_name_for_old_method, *args).class) != @__return_type 
          raise ReturnTypeError, [klass, @__return_type, method_name]
        else
          self.send(new_name_for_old_method, *args)
        end
      end
    end
  end
end
