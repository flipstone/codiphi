require_relative './spec_helper.rb'

describe DeclarationNode do 
  it "registers name into passed namespace" do
    node = declaration_mock("unit", "foo_squad", nil)
    namespace = {}

    node.gather_declarations(namespace)
    
    namespace.keys.should be_include "foo_squad"
    namespace["foo_squad"].should == "unit"
  end
end