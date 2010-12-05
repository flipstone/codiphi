require_relative './spec_helper.rb'

describe Codiphi::CostAssignmentNode do 
  
  it "assigns cost to new node" do
    parentnode = declaration_mock("fum", "baz")
    node = cost_assignment_mock('+',555, parentnode)

    indata = {
      "fum" => "baz"
    }
    
    node.completion_transform(indata, {})
    indata["fum"].class.should == Hash
    indata["fum"].keys.should be_include "cost"
    indata["fum"]["cost"].should == 555
  end

  it "increments data on +" do
      parentnode = declaration_mock("fum", "baz")
      node = cost_assignment_mock('+', 555, parentnode)

      indata = {
        "fum" => [{
          "type" => "baz",
          "cost" => 111
        }]
      }

      node.completion_transform(indata, {})
      indata["fum"][0].keys.should be_include "cost"
      indata["fum"][0]["cost"].should == 666
  end

  it "decrements data on -" do
      parentnode = declaration_mock("fum", "baz")
      node = cost_assignment_mock('-', 555, parentnode)

      indata = {
        "fum" => [{
          "type" => "baz",
          "cost" => 666
        }]
      }

      node.completion_transform(indata, {})
      indata["fum"][0].keys.should be_include "cost"
      indata["fum"][0]["cost"].should == 111
  end

end