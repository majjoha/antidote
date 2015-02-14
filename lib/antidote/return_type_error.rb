module Antidote
  class ReturnTypeError < StandardError
    def initialize(types)
      @actual_type, @expected_type, @method_name = types
    end

    def message
      "Expected `#{@method_name}` to return a #{@expected_type}, but it " \
      "returned a #{@actual_type} instead"
    end
  end
end
