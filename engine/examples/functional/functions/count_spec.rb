require_relative '../../spec_helper'

module Codiphi
  describe Functions, "count" do
    it "counts all with given type" do
      Functions[:count].call(
        {
          Tokens::Type => :bar,
          model: { Tokens::Type => :foo },
          models: [
            { Tokens::Type => :foo },
            { Tokens::Type => :baz },
            { Tokens::Type => :foo }
          ]
        },
        :foo).should == 3
    end

    it "takes count attributes into account" do
      Functions[:count].call(
        {
          Tokens::Type => :bar,
          model: { Tokens::Type => :foo },
          models: [
            { Tokens::Type => :foo, Tokens::Count => 2 },
            { Tokens::Type => :baz },
            { Tokens::Type => :foo, Tokens::Count => 3 }
          ]
        },
        :foo).should == 6
    end
  end
end
