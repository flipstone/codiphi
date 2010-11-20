require_relative 'spec_helper.rb'

describe CodiphiParser, "list" do
  parser = CodiphiParser.new

  it "parses" do
    parser.should parse %{list "foo" { cost_measure "pants" } }
    parser.should parse %{list "baz" {cost_measure "pants"}}
  end

  it "parses end of line comment" do
    parser.should parse %{list "foo" { cost_measure "pants"  # wooo ! \n} }
    parser.should parse %{list "foo" {cost_measure "pants"  # wooo ! \n}}
    parser.should parse %{list "foo" { cost_measure "pants"  # wooo ! \n}\n}
  end
  
  it "fails non string arguments" do
    parser.should_not parse %{list "" {cost_measure "pants"}}
    parser.should_not parse %{list :foo { cost_measure "pants" } }
    parser.should_not parse %{list foo { cost_measure "pants" } }
  end
end
