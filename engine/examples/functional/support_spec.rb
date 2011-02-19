require_relative '../spec_helper.rb'

module Codiphi
  describe Support do
    describe "recurseable?" do
      it "is true for hash" do
        Support.should be_recurseable({})
      end

      it "is true for array" do
        Support.should be_recurseable([])
      end

      it "is true for subclass of hash and array" do
        Support.should be_recurseable(Class.new(Hash).new)
        Support.should be_recurseable(Class.new(Array).new)
      end

      it "is false for String" do
        Support.should_not be_recurseable("foo")
      end

      it "is false for Fixnum" do
        Support.should_not be_recurseable(1)
      end

      it "is false for random type" do
        Support.should_not be_recurseable(Class.new.new)
      end
    end
  end
end
