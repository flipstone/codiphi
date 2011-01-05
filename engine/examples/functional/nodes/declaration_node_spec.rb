require_relative './spec_helper.rb'

describe Codiphi::DeclarationNode do 
  it "registers name into passed namespace" do
    node = declaration_mock("unit", "foo_squad", nil)
    namespace = Codiphi::Namespace.new

    node.gather_declarations(namespace)
    
    namespace.should be_named_type("foo_squad","unit")
  end
end