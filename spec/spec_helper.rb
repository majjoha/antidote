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

  def bar(x)
    x
  end
  annotate("bar", x: Fixnum)

  def baz(z)
    z.a + z.b
  end
  annotate("baz", z: CustomType)

  def self.quux(y, name)
    [name, y]
  end
  annotate("self.quux", y: Float, name: String)
end
