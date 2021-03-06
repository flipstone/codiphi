require_relative './spec_helper.rb'

describe Codiphi::DeclarationNode do 
  it "registers name into passed namespace" do
    node = Node :declaration, "unit :foo_squad"
    namespace, _ = node.gather_declarations(Codiphi::Namespace.new, [])
    namespace.should be_named_type("foo_squad","unit")
  end
end
