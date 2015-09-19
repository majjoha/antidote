require_relative 'lib/antidote'

class Adder
  include Antidote

  annotate Fixnum, Fixnum, Fixnum do
  def add(x, y)
    x + y
  end
  end
end

class Printer
  include Antidote

  annotate_class_method Adder, Fixnum do
  def self.print(adder)
    # FIXME: Both arguments should be Fixnums
    adder.add(1, "1")
  end
  end
end

begin
  puts Printer.print(Adder.new)
rescue Antidote::VariableTypeError
  puts "Please, fix `self.print', so it calls #add with only Fixnums."
end
