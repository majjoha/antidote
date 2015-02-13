$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require './lib/antidote'

class CustomType
  attr_accessor :a, :b

  def initialize(a, b)
    @a = a
    @b = b
  end
end

class Foo
  include Antidote

  annotate [[x: Fixnum], Fixnum],
  def bar(x)
    x
  end

  annotate [[z: CustomType], Fixnum],
  def baz(z)
    z.a + z.b
  end

  annotate [[a: Fixnum, b: Fixnum], String],
  def qux(a, b)
    a + b
  end

  annotate_class_method [[y: Float, name: String], Array],
  def self.quux(y, name)
    [name, y]
  end
end
