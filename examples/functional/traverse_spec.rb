require_relative '../spec_helper.rb'

module Codiphi
  describe Traverse do

    describe "matching_named_type" do
      it "yields proper hash reference to passed block" do
        indata = {
          "fum" => [{
            Tokens::Name => "baz",
            Tokens::Type => "fum"
          }]
        }

        Traverse.matching_named_type(indata, "fum", "baz") do |node|
          node["erkle"] = 999
        end
      
        indata["fum"][0].keys.should be_include("erkle")
        indata["fum"][0]["erkle"].should == 999
      end

      it "yields to multiple matches" do
        indata = {
          "foo" => {
            "fum" => [{
              Tokens::Name => "baz",
              "attr" => "aaa",
              Tokens::Type => "fum"
            },
            {
              Tokens::Name => "baz",
              "attr" => "bbb",
              Tokens::Type => "fum"
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
               Tokens::Type => "model"
            }],
            "attr1" => "attr1val",
            Tokens::Type => "list"
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
            Tokens::Name => "baz",
            Tokens::Type => "fum"
          }]
        }
      
        Traverse.matching_named_type(indata, "fum", "baz") do
          matches += 1
        end
        matches.should == 1
      end
    
      it "ignores non-immediate matches" do
        matches = 0
        indata = {
          "fum" => [{
            Tokens::Name => "baz",
            Tokens::Type => "fum"
          },
          {
            "fum" => [{
              "fum" => [{
                "fie" => [{
                  Tokens::Name => "baz",
                  Tokens::Type => "fie"
                }]
              }]
            }]
          }]
        }
      
        Traverse.matching_named_type(indata, "fum", "baz") do
          matches += 1
        end
        matches.should == 1
      end

      it "finds buried cases twice" do
        matches = 0
        indata = {
          "fum" => [{
            Tokens::Name => "baz",
            Tokens::Type => "fum"
          },
          {
            "fie" => [{
              "big" => [{
                "fum" => [{
                  Tokens::Name => "baz",
                  Tokens::Type => "fum"
                }]
              }]
            }]
          }]
        }
      
        Traverse.matching_named_type(indata, "fum", "baz") do
          matches += 1
        end
        matches.should == 2
      end

      it "doesn't yield when no matches" do
        matches = 0
        indata = {
          "list" => [{
            Tokens::Name => "baz",
            Tokens::Type => "list"
          }]
        }
      
        Traverse.matching_named_type(indata, "foo", "baz") do
          matches += 1
        end
        matches.should == 0
        
      end

      it "finds multiple matches" do
        matches = 0
        indata = {
          "fum" => [{
            Tokens::Name => "baz",
            Tokens::Type => "fum"
          },
          {
            Tokens::Name => "baz",
            Tokens::Type => "fum"
          }]
        }
      
        Traverse.matching_named_type(indata, "fum", "baz") do
          matches += 1
        end
        matches.should == 2
      end

    end

    describe "matching_key" do
      it "matches in Arrays" do
        indata = {
          "foo" => {
            Tokens::Name => "bar",
            Tokens::Type => "foo"
          },
          "foo" => [{
            Tokens::Name => "bar",
            Tokens::Type => "foo",
            "foo" => [{
              Tokens::Name => "baz",
              Tokens::Type => "foo"
            }]
          }]
        }

        count = 0
        Traverse.matching_key(indata, "foo") do |match|
          count += 1
        end
        
        count.should == 3
      end
    end


    describe "count_for_named_type simple" do
      it "counts 3-level case" do
        indata = {
          "bar" => {
            Tokens::Name => "baz",
            Tokens::Type => "bar",
            "count" => 3
          },
          "foo" => [{
            Tokens::Name => "foo",
            Tokens::Type => "bar",
            "count" => 3,
            "fum" => [{
              Tokens::Name => "baz",
              Tokens::Type => "fum",
              "count" => 2
            }]
          }]
        }
        Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 6
      end

      it "ignores counts on no match 2-level case" do
        indata = {
          "foo" => [{
            Tokens::Name => "foo",
            Tokens::Type => "bar",
            "count" => 3,
            "fum" => [{
              Tokens::Name => "fum",
              Tokens::Type => "bar",
              "count" => 2
            }]
          }]
        }
        # node expects 2 fum baz
        Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 0
      end

      it "counts 2-level case" do
        indata = {
          "foo" => [{
            Tokens::Name => "bar",
            Tokens::Type => "foo",
            "count" => 3,
            "fum" => [{
              Tokens::Name => "baz",
              Tokens::Type => "fum",
              "count" => 2
            }]
          }]
        }
        # node expects 2 fum baz
        Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 6
      end

      it "counts 2-sibling 2-level case" do
        indata = {
          "beedle" => [
            {
              Tokens::Name => "beedle",
              Tokens::Type => "bar",
              "count" => 3,
              "fum" => [{
                Tokens::Name => "baz",
                Tokens::Type => "fum",
                "count" => 2
              }]
            },
            {
              Tokens::Name => "beedle",
              Tokens::Type => "bar",
              "count" => 3,
              "fum" => [{
                Tokens::Name => "baz",
                Tokens::Type => "fum",
                "count" => 2
              }]
            }
          ]
        }
        # (beedle) node expects 12 fum baz
        Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 12
      end

      it "counts simple case" do
        indata = {
          "foo" => [{
            Tokens::Name => "bar",
            Tokens::Type => "foo",
            "count" => 2
          }]
        }
        # node expects 2 foo bar
        Traverse.count_for_expected_type_on_name(indata, "foo", "bar").should == 2
      end

      it "counts implicitly to 1" do
        indata = {
          "fum" => [{
            Tokens::Name => "baz",
            Tokens::Type => "fum"
          }]
        }

        # node expects 1 fum baz
        Traverse.count_for_expected_type_on_name(indata, "fum", "baz").should == 1
      end
    
    end
  end
end
