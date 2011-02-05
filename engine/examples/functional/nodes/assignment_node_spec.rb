require_relative './spec_helper.rb'

module Codiphi

  describe AssignmentNode do 

    describe "completion_transform" do

      it "decorates data on +" do
        parentnode = declaration_mock("fum", "baz")
        node = assignment_mock('+',"unit", "foopants", parentnode)

        namespace = Namespace.new
        namespace.add_named_type("foopants", "unit")

        indata = {
          "fum" => [{
            Tokens::Name => "baz",
            Tokens::Type => "fum"
          }]
        }

        outdata,_ = node.completion_transform(indata, namespace)
        outdata["fum"][0].keys.should be_include "unit"
        outdata["fum"][0]["unit"].should == "foopants"
      end

      it "removes data on -" do
        parentnode = declaration_mock("fum", "baz")
        node = assignment_mock('-', "unit", "foopants", parentnode)

        namespace = Hash.new
        namespace["foopants"] = "unit"

        indata = {
          "fum" => [{
            Tokens::Name => "baz",
            Tokens::Type => "fum",
            "unit" => {
              Tokens::Name => "foopants",
              Tokens::Type => "unit"
            }
          }]
        }

        outdata,_ = node.completion_transform(indata, namespace)
        outdata["fum"][0].keys.should_not be_include "unit"
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

        outdata,_ = node.completion_transform(indata, namespace)
        outdata["fum"][0].keys.should be_include "unit"
        outdata["fum"][0]["unit"].should == "baboons"
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
            Tokens::Name => "baz",
            Tokens::Type => "fum",
            "unit" => [
              {
                Tokens::Name => "baboons",
                Tokens::Type => "unit"
              },
              {
                Tokens::Name => "foopants",
                Tokens::Type => "unit"
              }
            ]
          }]
        }

        outdata,_ = node.completion_transform(indata, namespace)
        outdata["fum"][0]["unit"].count.should == 1
        outdata["fum"][0]["unit"][0]["type"].should == "baboons"
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
