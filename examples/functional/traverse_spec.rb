require_relative '../spec_helper.rb'

module Codiphi
  describe Traverse do

    describe "matching_named_type" do
      it "yields proper hash reference to passed block" do
        indata = {
          "fum" => [{
            SchematicNameKey => "baz",
            SchematicTypeKey => "fum"
          }]
        }

        Codiphi::Traverse.matching_named_type(indata, "fum", "baz") do |node|
          node["erkle"] = 999
        end
      
        indata["fum"][0].keys.should be_include("erkle")
        indata["fum"][0]["erkle"].should == 999
      end

      it "yields to multiple matches" do
        indata = {
          "foo" => {
            "fum" => [{
              SchematicNameKey => "baz",
              "attr" => "aaa",
              SchematicTypeKey => "fum"
            },
            {
              SchematicNameKey => "baz",
              "attr" => "bbb",
              SchematicTypeKey => "fum"
            }]
          }
        }

        Traverse.matching_named_type(indata, "fum", "baz") do |node|
          node["erkle"] = 999
        end
        fumnode = indata["foo"]["fum"]
        fumnode.each do |e|
          e.keys.should be_include("erkle")
          e["erkle"].should == 999
        end
      end


      it "matches list node parent declaration" do
        matches = 0
        indata = {
          "list" => {
            "model" => [{
              "type" => "baz",
               SchematicTypeKey => "model"
            }],
            "attr1" => "attr1val",
            SchematicTypeKey => "list"
          }
        }
      
        Traverse.matching_named_type(indata, "list", "list") do |node|
          node["erkle"] = 999
        end
      
        indata["list"].keys.should be_include("erkle")
        indata["list"]["erkle"].should == 999
      end

      it "finds a single case" do
        matches = 0
        indata = {
          "fum" => [{
            SchematicNameKey => "baz",
            SchematicTypeKey => "fum"
          }]
        }
      
        Codiphi::Traverse.matching_named_type(indata, "fum", "baz") do
          matches += 1
        end
        matches.should == 1
      end
    
      it "ignores non-immediate matches" do
        matches = 0
        indata = {
          "fum" => [{
            SchematicNameKey => "baz",
            SchematicTypeKey => "fum"
          },
          {
            "fum" => [{
              "fum" => [{
                "fie" => [{
                  SchematicNameKey => "baz",
                  SchematicTypeKey => "fie"
                }]
              }]
            }]
          }]
        }
      
        Codiphi::Traverse.matching_named_type(indata, "fum", "baz") do
          matches += 1
        end
        matches.should == 1
      end

      it "finds buried cases twice" do
        matches = 0
        indata = {
          "fum" => [{
            SchematicNameKey => "baz",
            SchematicTypeKey => "fum"
          },
          {
            "fie" => [{
              "big" => [{
                "fum" => [{
                  SchematicNameKey => "baz",
                  SchematicTypeKey => "fum"
                }]
              }]
            }]
          }]
        }
      
        Codiphi::Traverse.matching_named_type(indata, "fum", "baz") do
          matches += 1
        end
        matches.should == 2
      end

      it "doesn't yield when no matches" do
        matches = 0
        indata = {
          "list" => [{
            SchematicNameKey => "baz",
            SchematicTypeKey => "list"
          }]
        }
      
        Codiphi::Traverse.matching_named_type(indata, "foo", "baz") do
          matches += 1
        end
        matches.should == 0
        
      end

      it "finds multiple matches" do
        matches = 0
        indata = {
          "fum" => [{
            SchematicNameKey => "baz",
            SchematicTypeKey => "fum"
          },
          {
            SchematicNameKey => "baz",
            SchematicTypeKey => "fum"
          }]
        }
      
        Codiphi::Traverse.matching_named_type(indata, "fum", "baz") do
          matches += 1
        end
        matches.should == 2
      end

    end


    describe "count_for_named_type simple" do
      it "ignores counts on no match 2-level case" do
        indata = {
          "bar" => [{
            "type" => "baz",
            "count" => 3
          }],
          "foo" => [{
            "type" => "bar",
            "count" => 3,
            "fum" => [{
              "type" => "bar",
              "count" => 2
            }]
          }]
        }
        # node expects 2 fum baz
        Codiphi::Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 0
      end

      it "ignores counts on no match 2-level case" do
        indata = {
          "foo" => [{
            "type" => "bar",
            "count" => 3,
            "fum" => [{
              "type" => "bar",
              "count" => 2
            }]
          }]
        }
        # node expects 2 fum baz
        Codiphi::Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 0
      end

      it "counts 2-level case" do
        indata = {
          "foo" => [{
            "type" => "bar",
            "count" => 3,
            "fum" => [{
              "type" => "baz",
              "count" => 2
            }]
          }]
        }
        # node expects 2 fum baz
        Codiphi::Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 6
      end

      it "counts 2-sibling 2-level case" do
        indata = {
          "beedle" => [
            {
              "type" => "bar",
              "count" => 3,
              "fum" => [{
                "type" => "baz",
                "count" => 2
              }]
            },
            {
              "type" => "bar",
              "count" => 3,
              "fum" => [{
                "type" => "baz",
                "count" => 2
              }]
            }
          ]
        }
        # (beedle) node expects 12 fum baz
        Codiphi::Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 12
      end

      it "counts simple case" do
        indata = {
          "foo" => [{
            "type" => "bar",
            "count" => 2
          }]
        }
        # node expects 2 foo bar
        Codiphi::Traverse.count_for_expected_type_on_name(indata, "foo", "bar").should == 2
      end

      it "counts implicitly to 1" do
        indata = {
          "fum" => [{
            "type" => "baz"
          }]
        }

        # node expects 1 fum baz
        Codiphi::Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 1
      end
    
    end
  end
end
