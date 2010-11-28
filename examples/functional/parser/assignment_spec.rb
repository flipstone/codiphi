require_relative 'spec_helper.rb'

describe CodiphiParser, "assignment" do

  it "accepts + operator statements" do
    tree = Codiphi::Parser.parse %{model :pants { + cost 100 }}
    tree.class.should == CodexNode
    tree.declaration_list.class.should == DeclarationListNode
    decl = tree.declaration_list.declaration
    decl.class.should == DeclarationNode
    decl.declaration_block.class.should == DeclarationBlockNode
    
    Codiphi::Parser.should parse %{model :pants {+ cost 100 }}
    Codiphi::Parser.should parse %{model :pants {+\n \tcost 100\n }\n}
    Codiphi::Parser.should parse %{model :pants {\n \t+ cost 100  # love this price!\n }\n}
    Codiphi::Parser.should parse %{  model   :pants  {+   cost   100   }  }
  end

  it "correctly id's parent declarations" do
    tree = Codiphi::Parser.parse %{model :pants { + cost 100 }}
    decl = tree.declaration_list.declaration
    decl.class.should == DeclarationNode
    decl.parent_declaration_node.should be_nil
    
    assn = decl.declaration_block.declaration_list.declaration
    assn.class.should == AssignmentNode
    assn.parent_declaration_node.name.text_value.should == "pants"
  end

end