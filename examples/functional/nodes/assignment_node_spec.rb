require_relative './spec_helper.rb'

module Codiphi

  describe AssignmentNode do 

    describe "completion_transform" do

      it "decorates data on +" do
        parentnode = declaration_mock("fum", "baz")
        node = assignment_mock('+',"unit", "foopants", parentnode)

        namespace = Hash.new
        namespace["foopants"] = "foo"

        indata = {
          "fum" => [{
            SchematicNameKey => "baz",
            SchematicTypeKey => "fum"
          }]
        }

        node.completion_transform(indata, namespace)
        indata["fum"][0].keys.should be_include "unit"
        indata["fum"][0]["unit"].should == "foopants"
      end

      it "removes data on -" do
        parentnode = declaration_mock("fum", "baz")
        node = assignment_mock('-', "unit", "foopants", parentnode)

        namespace = Hash.new
        namespace["foopants"] = "unit"

        indata = {
          "fum" => [{
            SchematicNameKey => "baz",
            SchematicTypeKey => "fum",
            "unit" => {
              SchematicNameKey => "foopants",
              SchematicTypeKey => "unit"
            }
          }]
        }
    
        node.completion_transform(indata, namespace)
        indata["fum"][0].keys.should_not be_include "unit"
      end

      it "doesn't remove similarly typed data on -" do
        parentnode = declaration_mock("fum", "baz")
        node = assignment_mock('-',"unit", "foopants", parentnode)
    
        namespace = Hash.new
        namespace["foopants"] = "unit"
        namespace["baboons"] = "unit"
        namespace["baz"] = "fum"

        indata = {
          "fum" => [{
            "type" => "baz",
            "unit" => "baboons",
          }]
        }
    
        node.completion_transform(indata, namespace)
        indata["fum"][0].keys.should be_include "unit"
        indata["fum"][0]["unit"].should == "baboons"
      end

      it "removes only target type from array on -" do
        parentnode = declaration_mock("fum", "baz")
        node = assignment_mock('-',"unit", "foopants", parentnode)
    
        namespace = Hash.new
        namespace["foopants"] = "unit"
        namespace["baboons"] = "unit"
        namespace["baz"] = "fum"

        indata = {
          "fum" => [{
            SchematicNameKey => "baz",
            SchematicTypeKey => "fum",
            "unit" => [
              {
                SchematicNameKey => "baboons",
                SchematicTypeKey => "unit"
              },
              {
                SchematicNameKey => "foopants",
                SchematicTypeKey => "unit"
              }
            ]
          }]
        }
    
        node.completion_transform(indata, namespace)
        indata["fum"][0]["unit"].count.should == 1
        indata["fum"][0]["unit"][0]["type"].should == "baboons"
      end


    end  

    describe "gather_declarations" do
      it "throws error on premature assignment" do
        parentnode = declaration_mock("fum", "baz")
        node = assignment_mock('+',"unit", "foopants", parentnode)
    
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
end