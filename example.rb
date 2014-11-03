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
    @x += x
  end
  annotate("move", x: Fixnum, coordinates: Coordinates)

  def self.foo(y)
    puts y
  end
  annotate("self.foo", y: Fixnum)

  def booyah(z)
    puts "Booyah: #{y}"
  end
  annotate("booyah", z: Array(Float))
end

p = Point.new(1, 2)
c = Coordinates.new(3, 4)
Point.foo(5)
p.move(3, c)
p.booyah([3])
