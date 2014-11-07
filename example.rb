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

  def move(x, name)
    puts "x is #{x}, @x is #{@x}, name is #{name.x} #{name.y}"
  end
  annotate("move", x: Fixnum, coordinates: Coordinates)

  def self.foo(y)
    puts y
  end
  annotate("self.foo", y: Fixnum)
end

p = Point.new(1, 2)
c = Coordinates.new(3, 4)
Point.foo(5)
p.move(3, c)
