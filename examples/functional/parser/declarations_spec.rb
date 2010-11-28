require_relative 'spec_helper.rb'

describe CodiphiParser, "declaration" do

  it "accepts name argument" do
    Codiphi::Parser.should parse %{model :pants}
  end

  it "parses declarations without children" do
    Codiphi::Parser.should parse %{model :pants}
    Codiphi::Parser.should parse %{model :pants\n}
    Codiphi::Parser.should parse %{ model   :pants}
    Codiphi::Parser.should parse %{ model   :notab   \n} 
    Codiphi::Parser.should parse %{ model\t\t:wtabs\t\n}
  end
  
  it "parses assertions without children" do
    Codiphi::Parser.should parse %{expects 1 foo :argle}
    Codiphi::Parser.should parse %{\nexpects 1 foo :argle}
    Codiphi::Parser.should parse %{expects 99 foo :bargle\n}
    Codiphi::Parser.should parse %{\nexpects 99 foo :bargle\n}
  end
  
  it "parses without-children lists" do
    Codiphi::Parser.should parse %{model :foo model :baz}
    Codiphi::Parser.should parse %{model :foo\nargle :bargle}
    Codiphi::Parser.should parse %{model :foo\nargle :bargle\neasy :peasy\n expects 1 model :foo }
  end

  it "parses assertion-mixed, without-children lists" do
    Codiphi::Parser.should parse %{model :foo\n expects 1 foo :argle }
    Codiphi::Parser.should parse %{model :foo expects 1 foo :argle}
    Codiphi::Parser.should parse %{expects 1 foo :argle\nargle :bargle}
  end

  it "returns declaration_list nodes" do
    tree = Codiphi::Parser.parse %{model :foo\nargle :bargle}
    tree.class.should == CodexNode
    tree.declaration_list.class.should == DeclarationListNode
    tree.declaration_list.declaration_list.class.should == DeclarationListNode

    tree = Codiphi::Parser.parse %{model :foo\n expects 1 foo :argle }
    tree.class.should == CodexNode
    tree.declaration_list.class.should == DeclarationListNode
    tree.declaration_list.declaration_list.class.should == DeclarationListNode
  end
  
end
