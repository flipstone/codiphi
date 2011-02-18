require_relative '../spec_helper.rb'

module Codiphi
  describe Traverse do
    describe "matching_key" do
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
    
    describe "verify_named_types" do
      it "is quiet on declared type" do
        indata = {
          "fum" => [{
            Tokens::Name => "baz",
            Tokens::Type => "fum"
          }]
        }

        namespace = Namespace.new.add_named_type("baz","fum")

        errors = Traverse.verify_named_types(indata, namespace)
        errors.should be_empty
      end

      it "errors on bad name for declared type" do
        indata = {
          "qee" => [{
            Tokens::Name => "baz",
            Tokens::Type => "qee"
          }]
        }

        namespace = Namespace.new.add_named_type("boo","qee")

        errors = Traverse.verify_named_types(indata, namespace)
        errors.should_not be_empty
        errors.first.class.should == NoSuchNameException
      end

      it "errors on nested bad names" do
        indata = {
          "qee" => [{
            Tokens::Name => "bam",
            Tokens::Type => "qee"
          }],
          "qoo" => {
            Tokens::Name => "baz",
            Tokens::Type => "qee",
            "gom" => {
              "qee" => [{
                Tokens::Name => "buf",
                Tokens::Type => "qee"
              }]

            }
          }

        }

        namespace = Namespace.new
                    .add_named_type("boo","qee")
                    .add_named_type("baz","qee")

        errors = Traverse.verify_named_types(indata, namespace)
        errors.should have(2).items
      end
    end
  end
end
