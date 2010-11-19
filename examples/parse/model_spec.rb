require_relative 'spec_helper.rb'

describe CodiphiParser, "model" do
  parser = CodiphiParser.new

  it "parses without attributes" do
    parser.should parse 'model :pants'
    parser.should parse ' model   :pants'
    # parser.should parse ' model   :pants   \n'
  end

  it "parses with attributes" do
    parser.should parse 'model :pants { cost 100 }'
    parser.should parse '  model   :pants  {   cost   100   }  '
  end

end
