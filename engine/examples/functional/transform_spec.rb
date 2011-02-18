require_relative '../spec_helper.rb'

module Codiphi
  describe Transform do
    describe "matching_named_type" do
      it "yields proper hash reference to passed block" do
        indata = {
          "fum" => [{
            Tokens::Name => "baz",
            Tokens::Type => "fum"
          }]
        }

        yielded = nil
        Transform.matching_named_type(indata, "baz", "fum") do |node|
          yielded = node
        end

        yielded.should == indata["fum"].first
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

        yielded = []

        Transform.matching_named_type(indata, "baz", "fum") do |node|
          yielded << node
        end

        yielded.should have(2).nodes
        yielded.should include(indata["foo"]["fum"].first)
        yielded.should include(indata["foo"]["fum"].last)
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

        yielded = nil
        Transform.matching_named_type(indata, "list", "list") do |node|
          yielded = node
        end
        yielded.should == indata["list"]
      end

      it "finds a single case" do
        matches = 0
        indata = {
          "fum" => [{
            Tokens::Name => "baz",
            Tokens::Type => "fum"
          }]
        }

        Transform.matching_named_type(indata, "baz", "fum") do |n|
          matches += 1
          n
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

        Transform.matching_named_type(indata, "baz", "fum") do |n|
          matches += 1
          n
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

        Transform.matching_named_type(indata, "baz", "fum") do |n|
          matches += 1
          n
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

        Transform.matching_named_type(indata, "baz", "foo") do |n|
          matches += 1
          n
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

        Transform.matching_named_type(indata, "baz", "fum") do |n|
          matches += 1
          n
        end
        matches.should == 2
      end

      it "puts returned data into the output tree" do
        indata = {
          "fum" => [{
            Tokens::Name => "baz",
            Tokens::Type => "fum"
          }]
        }

        outdata = Transform.matching_named_type(indata, "baz", "fum") do |node|
          node.merge("erkle" => 999)
        end

        outdata["fum"].first["erkle"].should == 999
      end

    end

    describe "fold_type" do
      it "matches in Arrays" do
        indata = {
          "fee" => {
            Tokens::Name => "bim",
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

        Transform.fold_type(indata, "foo", 0) do |match, memo|
          memo + 1
        end.should == 3
      end
    end
  end
end
