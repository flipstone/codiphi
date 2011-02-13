require_relative '../spec_helper.rb'

module Codiphi
  describe Support do
    describe "recurseable?" do
      it "is true for hash" do
        Support.should be_recurseable({})
      end

      it "is true for array" do
        Support.should be_recurseable([])
      end

      it "is true for subclass of hash and array" do
        Support.should be_recurseable(Class.new(Hash).new)
        Support.should be_recurseable(Class.new(Array).new)
      end

      it "is false for String" do
        Support.should_not be_recurseable("foo")
      end

      it "is false for Fixnum" do
        Support.should_not be_recurseable(1)
      end

      it "is false for random type" do
        Support.should_not be_recurseable(Class.new.new)
      end
    end

    describe "remove_canonical_keys" do
      it "works" do
        input = {
          "a" => "b",
          "c" => [
            {
              Tokens::Name => "foo",
              Tokens::Type => "c"
            },
            {
              Tokens::Name => "bar",
              Tokens::Type => "c"
            }]
        }

        output = Support.remove_canonical_keys(input)
        output["c"].each do |e|
          e.keys.should_not be_include(Tokens::Type)
        end
      end

      it "doesn't modify input" do
        input = {
          "a" => "b",
          "c" => [
            {
              Tokens::Name => "foo",
              Tokens::Type => "c"
            },
            {
              Tokens::Name => "bar",
              Tokens::Type => "c"
            }]
        }

        original_input = Marshal.load(Marshal.dump(input))

        Support.remove_canonical_keys(input)

        input.should == original_input
      end
    end

    describe "expand_to_canonical" do
      it "expands single named types to Hash" do
        namespace = Namespace.new
        namespace.add_named_type("foo", "unit")

        input = {
          "unit" => "foo"
        }

        output = Support.expand_to_canonical(input, namespace)

        output["unit"].class.should == Hash
        output["unit"][Tokens::Name].should == "foo"
        output["unit"][Tokens::Type].should == "unit"
      end

      it "doesn't expand existing Hashes" do
        namespace = Namespace.new
        namespace.add_named_type("foo", "unit")

        input = {
          "c" =>
            {
              Tokens::Name => "foo",
              Tokens::Type => "c"
            }
        }

        output = Support.expand_to_canonical(input, namespace)

        output.should == input
      end

      it "applies Tokens::Type to Hash" do
        input = {
          "a" => "b",
          "c" => {
            Tokens::Name => "foo"
          }
        }

        output = Support.expand_to_canonical(input, Namespace.new)

        output["a"].should == "b"
        output["c"].keys.should include(Tokens::Type)
        output["c"][Tokens::Type].should == "c"
      end

      it "applies Tokens::Type to Array of Hash" do
        input = {
          "a" => "b",
          "c" => [
            {
              Tokens::Name => "foo"
            },
            {
              Tokens::Name => "bar"
            }]
        }

        output = Support.expand_to_canonical(input,Namespace.new)

        output["a"].should == "b"
        output["c"].each do |e|
          e.keys.should include(Tokens::Type)
          e[Tokens::Type].should == "c"
        end
      end

      it "applies Tokens::Type to nested Hash" do
        input = {
          "a" => [
            {
              Tokens::Name => "foo",
              "weapon" => {
                Tokens::Name => "weapon_type",
                "ammunition" => {
                  Tokens::Name => "hellfire_rounds"
                }
              }
            }]
        }

        output = Support.expand_to_canonical(input,Namespace.new)

        output["a"][0][Tokens::Type].should == "a"
        weapon = output["a"][0]["weapon"]
        weapon[Tokens::Type].should == "weapon"
        ammo = weapon["ammunition"]
        ammo[Tokens::Type].should == "ammunition"
      end

      it "doesn't modify the input hash" do
        namespace = Namespace.new
        namespace.add_named_type("foo", "unit")

        input = {
          "unit" => "foo"
        }

        output = Support.expand_to_canonical(input, namespace)

        input.should == {"unit" => "foo"}
      end
    end
  end
end
