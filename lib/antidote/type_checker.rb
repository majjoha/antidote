module Antidote
  class TypeChecker
    attr_accessor :target

    def initialize(target)
      @target = target
      @type_constraints = Hash.new { |h, k| h[k] = [] }
      puts "Running type checker!"
    end
  end
end
