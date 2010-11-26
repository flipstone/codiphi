require_relative 'spec_helper.rb'

describe CodiphiParser, "declaration" do

  it "accepts word argument" do
    Codiphi::Parser.should parse %{model pants}
  end

  it "accepts name argument" do
    Codiphi::Parser.should parse %{model :pants}
  end

  it "accepts string argument" do
    Codiphi::Parser.should parse %{model "pants"}
  end

  it "accepts integer argument" do
    Codiphi::Parser.should parse %{model 100}
  end

  it "parses declarations without children" do
    Codiphi::Parser.should parse %{model :pants}
    Codiphi::Parser.should parse %{model :pants\n}
    Codiphi::Parser.should parse %{ model   :pants}
    Codiphi::Parser.should parse %{ model   "notab"   \n} 
    Codiphi::Parser.should parse %{ model\t\t:wtabs\t\n}
  end
  
  it "parses assertions without children" do
    Codiphi::Parser.should parse %{expects 1 :argle}
    Codiphi::Parser.should parse %{\nexpects 1 :argle}
    Codiphi::Parser.should parse %{expects 99 :bargle\n}
    Codiphi::Parser.should parse %{\nexpects 99 :bargle\n}
  end
  
  it "parses without-children lists" do
    Codiphi::Parser.should parse %{model :foo model :baz}
    Codiphi::Parser.should parse %{model :foo\nargle "bargle"}
    Codiphi::Parser.should parse %{model :foo\nargle "bargle"\neasy "peasy"\n expects 1 :argle }
  end

  it "parses assertion-mixed, without-children lists" do
    Codiphi::Parser.should parse %{model :foo\n expects 1 :argle }
    Codiphi::Parser.should parse %{model :foo expects 1 :argle}
    Codiphi::Parser.should parse %{expects 1 :argle\nargle "bargle"}
  end

  it "parses with block" do
    tree = Codiphi::Parser.parse %{model :pants { cost 100 }}
    tree.class.should == CodexNode
    tree.declaration_list.class.should == DeclarationListNode
    decl = tree.declaration_list.declaration
    decl.class.should == DeclarationNode
    decl.declaration_block.class.should == DeclarationBlockNode
    
    Codiphi::Parser.should parse %{model :pants { cost 100 }}
    Codiphi::Parser.should parse %{model :pants {\n \tcost 100\n }\n}
    Codiphi::Parser.should parse %{model :pants {\n \tcost 100  # love this price!\n }\n}
    Codiphi::Parser.should parse %{  model   :pants  {   cost   100   }  }
  end

  it "returns declaration_list nodes" do
    tree = Codiphi::Parser.parse %{model :foo\nargle "bargle"}
    tree.class.should == CodexNode
    tree.declaration_list.class.should == DeclarationListNode
    tree.declaration_list.declaration_list.class.should == DeclarationListNode

    tree = Codiphi::Parser.parse %{model :foo\n expects 1 :argle }
    tree.class.should == CodexNode
    tree.declaration_list.class.should == DeclarationListNode
    tree.declaration_list.declaration_list.class.should == DeclarationListNode
  end
  
  it "correctly id's parent declarations" do
    tree = Codiphi::Parser.parse %{model :pants { cost 100 }}
    decl = tree.declaration_list.declaration
    decl.class.should == DeclarationNode
    decl.parent_declaration_node.should be_nil
    
    decl2 = decl.declaration_block.declaration_list.declaration
    decl2.class.should == DeclarationNode
    decl2.parent_declaration_node.declared.text_value.should == "pants"
  end
    
    

end
