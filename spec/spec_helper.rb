$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'coveralls'
require './lib/antidote'

Coveralls.wear!

class CustomType
  attr_accessor :a, :b

  def initialize(a, b)
    @a = a
    @b = b
  end
end

class Foo
  include Antidote

  annotate Fixnum, Fixnum do
  def bar(x)
    x
  end
  end

  annotate CustomType, Fixnum do
  def baz(z)
    z.a + z.b
  end
  end

  annotate Fixnum, Fixnum, String do
  def qux(a, b)
    a + b
  end
  end

  annotate_class_method Float, String, Array do
  def self.quux(y, name)
    [name, y]
  end
  end
end
