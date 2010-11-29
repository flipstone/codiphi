require_relative './spec_helper.rb'

describe CostAssignmentNode do 
  
  it "assigns cost on transform" do
    parentnode = declaration_mock("fum", "baz")
    node = cost_assignment_mock(555, parentnode)

    indata = {
      "fum" => [{
        "type" => "baz"
      }]
    }
    
    node.completion_transform(indata, {})
    indata["fum"][0].keys.should be_include "cost"
    indata["fum"][0]["cost"].should == 555
  end

  it "increments data on transform" do
      parentnode = declaration_mock("fum", "baz")
      node = cost_assignment_mock(555, parentnode)

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

end