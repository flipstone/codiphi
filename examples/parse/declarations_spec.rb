require_relative 'spec_helper.rb'

describe CodiphiParser, "declaration" do

  it "parses without children" do
    Codiphi::Parser.should parse %{model :pants}
    Codiphi::Parser.should parse %{model :pants\n}
    Codiphi::Parser.should parse %{ model   :pants}
    Codiphi::Parser.should parse %{ model   :notab   \n} 
    Codiphi::Parser.should parse %{ model\t\t:wtabs\t\n}
  end

  it "parses without-children lists" do
    Codiphi::Parser.should parse %{model :foo model :baz}
    Codiphi::Parser.should parse %{model :foo\nargle "bargle"}
  end

  it "parses permission-mixed, without-children lists" do
    Codiphi::Parser.should parse %{model :foo\n demands 1 :argle }
    Codiphi::Parser.should parse %{model :foo demands 1 :argle}
    Codiphi::Parser.should parse %{demands 1 :argle\nargle "bargle"}
  end

  it "parses with attributes" do
    Codiphi::Parser.should parse %{model :pants { cost 100 }}
    Codiphi::Parser.should parse %{model :pants {\n \tcost 100\n }\n}
    Codiphi::Parser.should parse %{model :pants {\n \tcost 100  # love this price!\n }\n}
    Codiphi::Parser.should parse %{  model   :pants  {   cost   100   }  }
  end

end
