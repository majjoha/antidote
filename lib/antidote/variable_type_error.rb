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
end
