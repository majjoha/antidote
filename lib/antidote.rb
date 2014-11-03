module Antidote
  class TypeError < StandardError
    def initialize(types)
      #@message = message
      @actual_type, @expected_type, @variable_name, @method_name = types
    end

    def message
      "Variable `#{@variable_name}` in method `#{@method_name}` expected a " \
      "#{@expected_type}, but received a #{@actual_type}"
    end
  end

  module ClassMethods
    @@type_constraints = Hash.new { |h, k| h[k] = [] }

    def annotate(method_name, type_constraints)
      type_constraints.each do |variable, type|
        add_type_constraint_for(method_name, {variable => type})
      end
      define_type_constrained_method(method_name)
    end

    def add_type_constraint_for(method, type_contract)
      @@type_constraints[method] << type_contract
    end

    def define_type_constrained_method(method_name, *args)
      if method_name.start_with?("self")
        define_singleton_method(method_name.split(".").last) do |*args|
          args.each_with_index do |argument_value, index|
            actual_type   = argument_value.class
            expected_type = @@type_constraints[method_name][index].values.first
            variable_name = @@type_constraints[method_name][index].keys.first

            unless actual_type == expected_type
              raise Antidote::TypeError,
                [actual_type, expected_type, variable_name, method_name]
            end
          end
        end
      else
        define_method(method_name) do |*args|
          args.each_with_index do |argument_value, index|
            actual_type   = argument_value.class
            expected_type = @@type_constraints[method_name][index].values.first
            variable_name = @@type_constraints[method_name][index].keys.first

            unless actual_type == expected_type
              raise Antidote::TypeError,
                [actual_type, expected_type, variable_name, method_name]
            end
          end
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
