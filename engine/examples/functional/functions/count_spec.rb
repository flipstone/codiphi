require_relative '../../spec_helper'

module Codiphi
  describe Functions, "count" do
    it "counts all with given type" do
      Functions[:count].call(
        {
          Tokens::Name => :bar,
          model: { Tokens::Name => :foo },
          models: [
            { Tokens::Name => :foo },
            { Tokens::Name => :baz },
            { Tokens::Name => :foo }
          ]
        },
        :foo).should == 3
    end

    it "takes count attributes into account" do
      Functions[:count].call(
        {
          Tokens::Name => :bar,
          model: { Tokens::Name => :foo },
          models: [
            { Tokens::Name => :foo, Tokens::Count => 2 },
            { Tokens::Name => :baz },
            { Tokens::Name => :foo, Tokens::Count => 3 }
          ]
        },
        :foo).should == 6
    end
  end
end
