require_relative 'spec_helper.rb'

describe Codiphi::Formula::Parser do
  it "parses an integer" do
    Codiphi::Formula::Parser.should parse "1"
  end

  it "parses basic arithmetic operations" do
    Codiphi::Formula::Parser.should parse "1 + 2"
    Codiphi::Formula::Parser.should parse "1 - 2"
    Codiphi::Formula::Parser.should parse "1 * 2"
    Codiphi::Formula::Parser.should parse "1 / 2"
    Codiphi::Formula::Parser.should parse "1+2"
    Codiphi::Formula::Parser.should parse "1-2"
    Codiphi::Formula::Parser.should parse "1*2"
    Codiphi::Formula::Parser.should parse "1/2"
  end

  it "parses multiple arithmetic operations with parentheticals" do
    Codiphi::Formula::Parser.should parse "1 + 2 + 3"
    Codiphi::Formula::Parser.should parse "1 * 2 + 3"
    Codiphi::Formula::Parser.should parse "1 + 2 * 3"
    Codiphi::Formula::Parser.should parse "1 / 2 - 3"
    Codiphi::Formula::Parser.should parse "1 - 2 / 3"
    Codiphi::Formula::Parser.should parse "1 - 2 / 3 + 4 * 5"
  end

  it "parses parentheticals" do
    Codiphi::Formula::Parser.should parse "(1)"
    Codiphi::Formula::Parser.should parse "(1 + 2)"
    Codiphi::Formula::Parser.should parse "1 + (2)"
    Codiphi::Formula::Parser.should parse "1 * (2 + 3)"
    Codiphi::Formula::Parser.should parse "(1 * 2) + 3"
  end

  it "doesn't parse unmatch parentheses" do
    Codiphi::Formula::Parser.should_not parse "("
    Codiphi::Formula::Parser.should_not parse ")"
    Codiphi::Formula::Parser.should_not parse "1)"
    Codiphi::Formula::Parser.should_not parse "(1"
    Codiphi::Formula::Parser.should_not parse "((1 + 2)"
    Codiphi::Formula::Parser.should_not parse "(1 + 2))"
    Codiphi::Formula::Parser.should_not parse "(1) + 2)"
  end

  it "parses function references" do
    Codiphi::Formula::Parser.should parse "foo(:bar)"
    Codiphi::Formula::Parser.should parse "baz(:bat)"
    Codiphi::Formula::Parser.should parse "3 * baz(:bat)"
    Codiphi::Formula::Parser.should parse "baz(:bat) - 3"
  end
end
