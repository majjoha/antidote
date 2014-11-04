require 'spec_helper'

describe Antidote do
  describe Foo do
    describe "#bar" do
      it "raises an error when the method is given the wrong type" do
        expect { Foo.new.bar(5.4) }.to raise_error
      end

      it "returns x when given the right argument" do
        expect(Foo.new.bar(5)).to eq 5
      end
    end

    describe ".quux" do
      it "raises an error when the method is given the wrong types" do
        expect { Foo.quux(43, 6.66) }.to raise_error
      end

      it "returns [name, y] when given the right arguments" do
        expect(Foo.quux(6.66, "Hello")).to eq ["Hello", 6.66]
      end
    end
  end
end
