require_relative 'spec_helper.rb'

describe CodiphiParser, "literals" do

  it "NameNode crops name tokens" do
    node = NameNode.new(":foo", 0..4)
    node.text_value.should == "foo"
  end
  
end