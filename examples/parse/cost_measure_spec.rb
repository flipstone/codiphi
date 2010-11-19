require_relative 'spec_helper.rb'

describe CodiphiParser, "cost_measure" do
  parser = CodiphiParser.new

  it "parses" do
    parser.should parse %{"cost_measure "pants"}
    parser.should parse %{ cost_measure "pants" }
  end

  it "parses end of line comment" do
    parser.should parse %{cost_measure "pants"}
    parser.should parse %{ cost_measure "pants"  # wooo ! }
    parser.should parse %{cost_measure "pants"  # wooo ! \n}
    parser.should parse %{ cost_measure "pants"  # wooo ! \n}
  end
  
  it "fails non string arguments" do
    parser.should_not parse %{cost_measure :pants}
    parser.should_not parse %{cost_measure pants}
  end
end
