require_relative './spec_helper.rb'

describe DeclarationNode do 
  it "decorates data on transform" do
    parentnode = declaration_mock("fum", "baz")
    node = declaration_mock("foo", "foopants", parentnode)

    indata = {
      "fum" => [{
        "type" => "baz"
      }]
    }
    node.type.text_value.should == "foo"
    
    node.completion_transform(indata)
    indata["fum"][0].keys.should be_include "foo"
    indata["fum"][0]["foo"].should == "foopants"
  end
end