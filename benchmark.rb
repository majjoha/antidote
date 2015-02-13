require_relative "lib/antidote"
require "benchmark/ips"

class Point
  include Antidote

  annotate [[x: Fixnum], Fixnum],
  def foo(x)
    x
  end

  annotate_class_method [[y: Float], Float],
  def self.bar(y)
    y
  end

  def baz(q)
    q
  end

  def self.qux(z)
    z
  end
end

n = 1_000_000

# Type checking instance methods is ~644.44 percent slower than running them
# without type checking.
#
# Type checking class methods is ~1600 percent slower than running them without
# type checking.

Benchmark.ips do |x|
  x.report("Instance method with type checking") do
    n.times do
      Point.new.foo(5)
    end
  end

  x.report("Class method with type checking") do
    n.times do
      Point.bar(5.5)
    end
  end

  x.report("Instance method without type checking") do
    n.times do
      Point.new.baz(5)
    end
  end

  x.report("Class method without type checking") do
    n.times do
      Point.qux(5.5)
    end
  end
end
