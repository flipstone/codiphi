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

    #describe "matching_key" do
    #  it "matches in Arrays" do
    #    indata = {
    #      "fee" => {
    #        Tokens::Name => "bim",
    #        Tokens::Type => "foo"
    #      },
    #      "foo" => [{
    #        Tokens::Name => "bar",
    #        Tokens::Type => "foo",
    #        "foo" => [{
    #          Tokens::Name => "baz",
    #          Tokens::Type => "foo"
    #        }]
    #      }]
    #    }

    #    count = 0
    #    Transform.matching_key(indata, "foo") do |match|
    #      count += 1
    #    end
    #    
    #    count.should == 3
    #  end
    #end


    #describe "count_for_named_type simple" do
    #  it "counts 3-level case" do
    #    indata = {
    #      "bar" => {
    #        Tokens::Name => "baz",
    #        Tokens::Type => "bar",
    #        "count" => 3
    #      },
    #      "foo" => [{
    #        Tokens::Name => "foo",
    #        Tokens::Type => "bar",
    #        "count" => 3,
    #        "fum" => [{
    #          Tokens::Name => "baz",
    #          Tokens::Type => "fum",
    #          "count" => 2
    #        }]
    #      }]
    #    }
    #    Transform.count_for_expected_type_on_name(indata, "fum", "baz").should == 6
    #  end

    #  it "ignores counts on no match 2-level case" do
    #    indata = {
    #      "foo" => [{
    #        Tokens::Name => "foo",
    #        Tokens::Type => "bar",
    #        "count" => 3,
    #        "fum" => [{
    #          Tokens::Name => "fum",
    #          Tokens::Type => "bar",
    #          "count" => 2
    #        }]
    #      }]
    #    }
    #    # node expects 2 fum baz
    #    Transform.count_for_expected_type_on_name(indata, "fum", "baz").should == 0
    #  end

    #  it "counts 2-level case" do
    #    indata = {
    #      "foo" => [{
    #        Tokens::Name => "bar",
    #        Tokens::Type => "foo",
    #        "count" => 3,
    #        "fum" => [{
    #          Tokens::Name => "baz",
    #          Tokens::Type => "fum",
    #          "count" => 2
    #        }]
    #      }]
    #    }
    #    # node expects 2 fum baz
    #    Transform.count_for_expected_type_on_name(indata, "fum", "baz").should == 6
    #  end

    #  it "counts 2-sibling 2-level case" do
    #    indata = {
    #      "beedle" => [
    #        {
    #          Tokens::Name => "beedle",
    #          Tokens::Type => "bar",
    #          "count" => 3,
    #          "fum" => [{
    #            Tokens::Name => "baz",
    #            Tokens::Type => "fum",
    #            "count" => 2
    #          }]
    #        },
    #        {
    #          Tokens::Name => "beedle",
    #          Tokens::Type => "bar",
    #          "count" => 3,
    #          "fum" => [{
    #            Tokens::Name => "baz",
    #            Tokens::Type => "fum",
    #            "count" => 2
    #          }]
    #        }
    #      ]
    #    }
    #    # (beedle) node expects 12 fum baz
    #    Transform.count_for_expected_type_on_name(indata, "fum", "baz").should == 12
    #  end

    #  it "counts simple case" do
    #    indata = {
    #      "foo" => [{
    #        Tokens::Name => "bar",
    #        Tokens::Type => "foo",
    #        "count" => 2
    #      }]
    #    }
    #    # node expects 2 foo bar
    #    Transform.count_for_expected_type_on_name(indata, "foo", "bar").should == 2
    #  end

    #  it "counts implicitly to 1" do
    #    indata = {
    #      "fum" => [{
    #        Tokens::Name => "baz",
    #        Tokens::Type => "fum"
    #      }]
    #    }

    #    # node expects 1 fum baz
    #    Transform.count_for_expected_type_on_name(indata, "fum", "baz").should == 1
    #  end
    #end
    #
    #describe "verify_named_types" do
    #  it "is quiet on declared type" do
    #    indata = {
    #      "fum" => [{
    #        Tokens::Name => "baz",
    #        Tokens::Type => "fum"
    #      }]
    #    }

    #    namespace = Namespace.new
    #    namespace.add_named_type("baz","fum")
    #    
    #    Transform.verify_named_types(indata, namespace)
    #    namespace.should_not have_errors
    #  end

    #  it "errors on bad name for declared type" do
    #    indata = {
    #      "qee" => [{
    #        Tokens::Name => "baz",
    #        Tokens::Type => "qee"
    #      }]
    #    }

    #    namespace = Namespace.new
    #    namespace.add_named_type("boo","qee")
    #    
    #    Transform.verify_named_types(indata, namespace)
    #    namespace.should have_errors
    #    namespace.errors[0].class.should == NoSuchNameException
    #  end

    #  it "errors on nested bad names" do
    #    indata = {
    #      "qee" => [{
    #        Tokens::Name => "bam",
    #        Tokens::Type => "qee"
    #      }],
    #      "qoo" => {
    #        Tokens::Name => "baz",
    #        Tokens::Type => "qee",
    #        "gom" => {
    #          "qee" => [{
    #            Tokens::Name => "buf",
    #            Tokens::Type => "qee"
    #          }]
    #          
    #        }
    #      }
    #      
    #    }

    #    namespace = Namespace.new
    #    namespace.add_named_type("boo","qee")
    #    namespace.add_named_type("baz","qee")
    #    
    #    Transform.verify_named_types(indata, namespace)
    #    namespace.should have_errors
    #    namespace.errors.count.should == 2
    #  end

    #end
    
  end
end
