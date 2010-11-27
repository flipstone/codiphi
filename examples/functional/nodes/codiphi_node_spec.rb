require_relative './spec_helper.rb'

describe CodiphiNode do 
  it "parent_declaration_node" do
    input = "fumfoodiddly"
    parentnode = CodiphiNode.new(input, 0..5)
    parentnode.stubs(:declarative?).returns(true)
    node1 = CodiphiNode.new(input, 0..2)
    node1.parent = parentnode
    node2 = CodiphiNode.new(input, 3..5)
    node2.parent = parentnode

    node1.parent.should == parentnode
    node2.parent.should == parentnode
    
    node1.parent_declaration_node.should == parentnode
    node2.parent_declaration_node.should == parentnode
  end
end