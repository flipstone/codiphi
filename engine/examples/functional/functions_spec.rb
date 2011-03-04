require_relative '../spec_helper'

module Codiphi
  describe Functions do
    describe "curry_data" do
      it "curries the first argument of the function" do
        Functions.curry_data({
          Tokens::Type => :foo
        })[:count].call(:foo).should == 1
      end
    end

    describe "[]" do
      it "raises an error when accessing an undefined function" do
        -> do
          Functions[:foobarbaz]
        end.should raise_error Codiphi::Functions::UndefinedFunctionError, /foobarbaz/
      end
    end
  end
end
