require_relative './spec_helper.rb'

describe AssignmentNode do 
  
  it "decorates data on transform" do
    parentnode = declaration_mock("fum", "baz")
    node = assignment_mock("unit", "foopants", parentnode)
    
    namespace = Hash.new
    namespace["foopants"] = "foo"

    indata = {
      "fum" => [{
        "type" => "baz"
      }]
    }
    
    node.completion_transform(indata, namespace)
    indata["fum"][0].keys.should be_include "unit"
    indata["fum"][0]["unit"].should == "foopants"
  end
  
  describe "gather_declarations" do
    it "throws error on premature assignment" do
      parentnode = declaration_mock("fum", "baz")
      node = assignment_mock("unit", "foopants", parentnode)
    
      namespace = Codiphi::Namespace.new

      indata = {
        "fum" => [{
          "type" => "baz"
        }]
      }
    
    node.gather_declarations(namespace)
    
    namespace.errors.should_not be_nil
    namespace.errors[0].class.should == Codiphi::NoSuchNameException
    
    end
  end
end