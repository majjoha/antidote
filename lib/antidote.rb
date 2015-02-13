require_relative 'antidote/type_checker'
require_relative "antidote/variable_type_error"
require_relative "antidote/return_type_error"

module Antidote
  module ClassMethods
    @@type_constraints = Hash.new { |h, k| h[k] = [] }

    def annotate(type_constraints, method_name)
      add_type_constraints(method_name, type_constraints)
      define_type_check_for_instance_method(method_name)
    end

    def annotate_class_method(type_constraints, method_name)
      add_type_constraints("self.#{method_name}", type_constraints)
      define_type_check_for_class_method("self.#{method_name}")
    end

    private

    def add_type_constraints(method_name, type_constraints)
      type_constraints.first.each do |variable|
        @@type_constraints[method_name] << variable
      end

      @@type_constraints[method_name] << {__returns: type_constraints.last}
    end

    def define_type_check_for_class_method(method_name)
      method_name = method_name.split(".").last
      new_name_for_old_function = "#{method_name}_old".to_sym
      self.singleton_class.send(:alias_method, new_name_for_old_function,
                                method_name)

      define_singleton_method(method_name) do |*args|
        args.each_with_index do |argument_value, index|
          actual_type   = argument_value.class
          expected_type =
            @@type_constraints["self.#{method_name}"].first.values[index]
          variable_name =
            @@type_constraints["self.#{method_name}"].first.keys[index]
          @@return_type = @@type_constraints["self.#{method_name}"].last.values.first

          unless actual_type == expected_type
            raise Antidote::VariableTypeError,
              [actual_type, expected_type, variable_name, "self.#{method_name}"]
          end
        end

        if (klass = send(new_name_for_old_function, *args).class) != @@return_type
          raise Antidote::ReturnTypeError, [klass, @@return_type, "self.#{method_name}"]
        else
          self.send(new_name_for_old_function, *args)
        end
      end
    end

    def define_type_check_for_instance_method(method_name)
      new_name_for_old_function = "#{method_name}_old".to_sym
      alias_method(new_name_for_old_function, method_name)

      define_method(method_name) do |*args|
        args.each_with_index do |argument_value, index|
          actual_type   = argument_value.class
          expected_type = @@type_constraints[method_name].first.values[index]
          variable_name = @@type_constraints[method_name].first.keys[index]

          @@return_type = @@type_constraints[method_name].last.values.first

          unless actual_type == expected_type
            raise Antidote::VariableTypeError,
              [actual_type, expected_type, variable_name, method_name]
          end
        end

        if (klass = send(new_name_for_old_function, *args).class) != @@return_type
          raise Antidote::ReturnTypeError, [klass, @@return_type, method_name]
        else
          send(new_name_for_old_function, *args)
        end
      end
    end
  end

  class << self
    def included(klass)
      klass.extend(ClassMethods)
    end
  end
end
