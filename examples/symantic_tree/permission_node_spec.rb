require_relative '../spec_helper.rb'

def mocked_node(opval, intval, nameval)
  input = "#{opval} #{intval} #{nameval}"
  op =   stub(text_value: opval)
  int =  stub(text_value: intval)
  name = stub(text_value: nameval)
  node = AssertionNode.new(input, 0..input.length, [op,int,name])
end

describe AssertionNode do 
  it "adds itself to passed context on transform" do
    node = mocked_node("foopants", 99, "foopants")
    context = {}
    node.transform({}, context)
    context["assertions"].should_not be_nil
    context["assertions"].should be_include node
  end
end