require_relative './spec_helper.rb'

describe AssertionNode do 
  it "adds itself to passed context on transform" do
    node = assertion_mock("expects", 99, "foo", "pants")
    list = []
    node.gather_assertions(list)
    list.should_not be_nil
    list.should be_include node
  end
end