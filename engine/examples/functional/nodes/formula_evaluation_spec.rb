require_relative './spec_helper.rb'

module Codiphi
  describe "formula" do
    def self.it_evals(formula, options)
      expected = options[:to]
      it "#{formula} evals to #{expected}" do
        Codiphi::Formula::Parser.parse(formula).evaluate(options[:with]).should == expected
      end
    end

    it_evals "1", to: 1
    it_evals "1 + 3", to: 4
    it_evals "1 - 3", to: -2
    it_evals "2 * 3", to: 6
    it_evals "6 / 2", to: 3
    it_evals "2 + 3 + 4", to: 9
    it_evals "2 + 3 - 4", to: 1
    it_evals "2 - 3 + 4", to: 3
    it_evals "2 + 3 * 4", to: 14
    it_evals "2 * 3 + 4", to: 10
    it_evals "5 + 6 / 2", to: 8
    it_evals "6 / 3 + 1", to: 3
    it_evals "3 + 6 / 3 + 1", to: 6

    it_evals "(3 + 6) / 3 + 1", to: 4
    it_evals "(3 + 6) / (2 + 1)", to: 3

    it_evals "foo(:bar)", to: 1, with: {
      foo: -> x { x == 'bar' ? 1 : nil }
    }

    it_evals "foo(:bar) + 2", to: 3, with: {
      foo: -> x { x == 'bar' ? 1 : nil }
    }

    it_evals "2 + foo(:bar)", to: 3, with: {
      foo: -> x { x == 'bar' ? 1 : nil }
    }
  end
end
