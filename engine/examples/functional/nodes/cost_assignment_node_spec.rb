require_relative './spec_helper.rb'

module Codiphi
  describe CostAssignmentNode do
    it "assigns cost to new node" do
      parentnode = declaration_mock("fum", "baz")
      node = cost_assignment_mock('+',555, parentnode)

      indata = {
        "fum" => {
          Tokens::Name => "baz",
          Tokens::Type => "fum"
        }
      }

      outdata,_ = node.completion_transform(indata, {})
      outdata["fum"].class.should == Hash
      outdata["fum"].keys.should be_include "cost"
      outdata["fum"].cost_value.should == 555
    end

    it "sets data on =" do
        parentnode = declaration_mock("fum", "baz")
        node = cost_assignment_mock('=', 555, parentnode)

        indata = {
          "fum" => [{
            Tokens::Name => "baz",
            Tokens::Type => "fum",
            "cost" => 111
          }]
        }

        outdata,_ = node.completion_transform(indata, {})
        outdata["fum"][0].keys.should be_include "cost"
        outdata["fum"][0].cost_value.should == 555
    end

    it "increments data on +" do
        parentnode = declaration_mock("fum", "baz")
        node = cost_assignment_mock('+', 555, parentnode)

        indata = {
          "fum" => [{
            Tokens::Name => "baz",
            Tokens::Type => "fum",
            "cost" => 111
          }]
        }

        outdata,_ = node.completion_transform(indata, {})
        outdata["fum"][0].keys.should be_include "cost"
        outdata["fum"][0].cost_value.should == 555
    end

    it "decrements data on -" do
        parentnode = declaration_mock("fum", "baz")
        node = cost_assignment_mock('-', 555, parentnode)

        indata = {
          "fum" => [{
            Tokens::Name => "baz",
            Tokens::Type => "fum",
            "cost" => 666
          }]
        }

        outdata,_ = node.completion_transform(indata, {})
        outdata["fum"][0].keys.should be_include "cost"
        outdata["fum"][0].cost_value.should == -555
    end

    it "calculates cost from formula" do
      parentnode = declaration_mock("fum", "baz")
      node = cost_assignment_mock(
        '+',Formula::Parser.parse("count(:fee) * 3"), parentnode
      )

      indata = {
        "fum" => {
          Tokens::Name => "baz",
          Tokens::Type => "fum",
          "fee" => {
            Tokens::Name => "foo",
            Tokens::Type => "fee",
            Tokens::Count => 2
          }
        }
      }

      outdata,_ = node.completion_transform(indata, {})
      outdata["fum"].class.should == Hash
      outdata["fum"].keys.should be_include "cost"
      outdata["fum"].cost_value.should == 6
    end
  end
end
