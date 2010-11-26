require_relative 'spec_helper.rb'

describe Codiphi::Parser, "list" do

  it "parses" do
    Codiphi::Parser.should parse %{list { cost_measure pants } }
    Codiphi::Parser.should parse %{list{cost_measure pants}}
  end

  it "parses end of line comment" do
    Codiphi::Parser.should parse %{list { cost_measure "pants"  # wooo ! \n} }
    Codiphi::Parser.should parse %{list  {cost_measure "pants"  # wooo ! \n}}
    Codiphi::Parser.should parse %{list \n { cost_measure "pants"  # wooo ! \n}\n}
  end
  
  it "fails when provided a description" do
    Codiphi::Parser.should_not parse %{list "" {cost_measure "pants"}}
    Codiphi::Parser.should_not parse %{list :foo { cost_measure "pants" } }
    Codiphi::Parser.should_not parse %{list "foo" { cost_measure "pants" } }
    Codiphi::Parser.should_not parse %{list foo { cost_measure "pants" } }
  end
  
  it "parses block" do
    tree = Codiphi::Parser.parse %{model :hero {\n  cost 100\n} \n list { \ncost_measure "points"\n expects 1 model :hero  \n }\n }
    tree.class.should == CodexNode
    tree.elements.map{ |e| e.class }.should be_include ListNode
  end
end
