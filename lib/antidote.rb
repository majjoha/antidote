module Antidote
  class VariableTypeError < StandardError
    def initialize(types)
      @actual_type, @expected_type, @variable_name, @method_name = types
    end

    def message
      "Variable `#{@variable_name}` in method `#{@method_name}` expected a " \
      "#{@expected_type}, but received a #{@actual_type}"
    end
  end

  module ClassMethods
    @@type_constraints = Hash.new { |h, k| h[k] = [] }

    def add_type_constraint_for(method_name, type_constraint)
      @@type_constraints[method_name] << {variable => type}
    end

    def annotate(method_name, type_constraints)
      type_constraints.each do |variable, type|
        @@type_constraints[method_name] << {variable => type}
      end

      if method_name.start_with?("self")
        method_name = method_name.split(".").last
        new_name_for_old_function = "#{method_name}_old".to_sym
        self.singleton_class.send(:alias_method, new_name_for_old_function,
                                    method_name)
        define_singleton_method(method_name) do |*args|
          args.each_with_index do |argument_value, index|
            actual_type   = argument_value.class
            expected_type =
              @@type_constraints["self.#{method_name}"][index].values.first
            variable_name =
              @@type_constraints["self.#{method_name}"][index].keys.first

            unless actual_type == expected_type
              raise Antidote::VariableTypeError,
                [actual_type, expected_type, variable_name, "self.#{method_name}"]
            end
          end
          self.send(new_name_for_old_function, *args)
        end
      else
        new_name_for_old_function = "#{method_name}_old".to_sym
        alias_method(new_name_for_old_function, method_name)
        define_method(method_name) do |*args|
          args.each_with_index do |argument_value, index|
            actual_type   = argument_value.class
            expected_type = @@type_constraints[method_name][index].values.first
            variable_name = @@type_constraints[method_name][index].keys.first

            unless actual_type == expected_type
              raise Antidote::VariableTypeError,
                [actual_type, expected_type, variable_name, method_name]
            end
          end
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
