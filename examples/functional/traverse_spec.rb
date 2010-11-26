require_relative '../spec_helper.rb'

describe Codiphi::Traverse do
  describe "count_for_named_type simple" do

    it "ignores counts on no match 2-level case" do
      indata = {
        "bar" => {
          "type" => "baz",
          "count" => 3,
        },
        "foo" => {
          "type" => "bar",
          "count" => 3,
          "fum" => {
            "type" => "bar",
            "count" => 2
          }
        }
      }
      # node expects 2 fum baz
      Codiphi::Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 0
    end

    it "ignores counts on no match 2-level case" do
      indata = {
        "foo" => {
          "type" => "bar",
          "count" => 3,
          "fum" => {
            "type" => "bar",
            "count" => 2
          }
        }
      }
      # node expects 2 fum baz
      Codiphi::Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 0
    end

    it "counts 2-level case" do
      indata = {
        "foo" => {
          "type" => "bar",
          "count" => 3,
          "fum" => {
            "type" => "baz",
            "count" => 2
          }
        }
      }
      # node expects 2 fum baz
      Codiphi::Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 6
    end

    it "counts 2-sibling 2-level case" do
      indata = {
        "beedle" => {
          "foo" => {
            "type" => "bar",
            "count" => 3,
            "fum" => {
              "type" => "baz",
              "count" => 2
            }
          },
          "fie" => {
            "type" => "bar",
            "count" => 3,
            "fum" => {
              "type" => "baz",
              "count" => 2
            }
          }
        }
      }
      # (beedle) node expects 12 fum baz
      Codiphi::Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 12
    end

    it "counts simple case" do
      indata = {
        "foo" => {
          "type" => "bar",
          "count" => 2
        }
      }
      # node expects 2 foo bar
      Codiphi::Traverse.count_for_expected_type_on_name(indata, "foo", "bar").should == 2
    end

    it "counts implicitly to 1" do
      indata = {
        "fum" => {
          "type" => "baz"        }
      }

      # node expects 1 fum baz
      Codiphi::Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 1
    end
    
  end
end
