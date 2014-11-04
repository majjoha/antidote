$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require './lib/antidote'

class Foo
  include Antidote

  def bar(x)
    x
  end
  annotate("bar", x: Fixnum)

  def self.quux(y, name)
    [name, y]
  end
  annotate("self.quux", y: Float, name: String)
end
