require_relative 'spec_helper.rb'

describe CodiphiParser, "model" do

  it "parses without attributes" do
    Codiphi::Parser.should parse %{model :pants}
    Codiphi::Parser.should parse %{model :pants\n}
    Codiphi::Parser.should parse %{ model   :pants}
    Codiphi::Parser.should parse %{ model   :notab   \n} 
    Codiphi::Parser.should parse %{ model\t\t:wtabs\t\n}
  end

  it "parses with attributes" do
    Codiphi::Parser.should parse %{model :pants { cost 100 }}
    Codiphi::Parser.should parse %{model :pants {\n \tcost 100\n }\n}
    Codiphi::Parser.should parse %{model :pants {\n \tcost 100  # love this price!\n }\n}
    Codiphi::Parser.should parse %{  model   :pants  {   cost   100   }  }
  end

end
