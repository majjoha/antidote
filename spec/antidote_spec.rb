require 'spec_helper'

describe Antidote do
  describe Foo do
    let(:foo) { Foo.new }

    describe "#bar" do
      it "raises an error when the method is given the wrong type" do
        expect { foo.bar(5.4) }.to raise_error
      end

      it "returns x when given the right argument" do
        expect(foo.bar(5)).to eq 5
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

    describe "#baz" do
      let(:custom_type) { CustomType.new(1, 2) }

      it "raises an error when the method is given the wrong types" do
        expect { foo.baz(5.5) }.to raise_error
      end

      it "returns x.a + x.b when given the right arguments" do
        expect(foo.baz(custom_type)).to eq 3
      end
    end
  end
end
