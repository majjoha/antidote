require_relative 'lib/antidote'

class Coordinates
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Point
  include Antidote

  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  annotate Fixnum, Coordinates, Fixnum do
  def move(x, name)
    puts "x is #{x}, @x is #{@x}, name is #{name.x} #{name.y}"
    5
  end
  end

  annotate_class_method Fixnum, Fixnum do
  def self.foo(y)
    y
  end
  end
end

p = Point.new(1, 2)
c = Coordinates.new(3, 4)
Point.foo(5)
p.move(3, c)
