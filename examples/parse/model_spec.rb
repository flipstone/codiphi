require_relative 'spec_helper.rb'

describe CodiphiParser, "model" do
  parser = CodiphiParser.new

  it "parses without attributes" do
    parser.should parse %{model :pants}
    parser.should parse %{model :pants\n}
    parser.should parse %{ model   :pants}
    parser.should parse %{ model   :notab   \n} 
    parser.should parse %{ model\t\t:wtabs\t\n}
  end

  it "parses with attributes" do
    parser.should parse %{model :pants { cost 100 }}
    parser.should parse %{model :pants {\n \tcost 100\n }\n}
    parser.should parse %{model :pants {\n \tcost 100  # love this price!\n }\n}
    parser.should parse %{  model   :pants  {   cost   100   }  }
  end

end
