module Antidote
  class ReturnTypeError < StandardError
    def initialize(types)
      @actual_type, @expected_type, @method_name = types
    end

    def message
      "`#{@method_name}` expected to return #{@expected_type}, but returned " \
      "a #{@actual_type}"
    end
  end
end
