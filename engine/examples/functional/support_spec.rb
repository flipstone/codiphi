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
        
        Support.remove_canonical_keys(input)
        input["c"].each do |e|
          e.keys.should_not be_include(Tokens::Type)
        end
      end
    end
    
    describe "expand_to_canonical" do
      it "expands single named types to Hash" do
        namespace = Namespace.new
        namespace.add_named_type("foo", "unit")
        
        input = {
          "unit" => "foo"
        }
        
        Support.expand_to_canonical(input, namespace)
        
        input["unit"].class.should == Hash
        input["unit"][Tokens::Name].should == "foo"
        input["unit"][Tokens::Type].should == "unit"
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
        
        input_copy = {
          "c" =>
            {
              Tokens::Name => "foo",
              Tokens::Type => "c"
            }
        }
        
        Support.expand_to_canonical(input, namespace)
        
        input.should == input_copy
      end

      it "applies Tokens::Type to Hash" do
        input = {
          "a" => "b",
          "c" => {
            Tokens::Name => "foo"
          }        
        }
      
        Support.expand_to_canonical(input, Namespace.new)
      
        input["a"].should == "b"
        input["c"].keys.should include(Tokens::Type)
        input["c"][Tokens::Type].should == "c"
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
      
        Support.expand_to_canonical(input,Namespace.new)
      
        input["a"].should == "b"
        input["c"].each do |e|
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
      
        Support.expand_to_canonical(input,Namespace.new)
      
        input["a"][0][Tokens::Type].should == "a"
        weapon = input["a"][0]["weapon"]
        weapon[Tokens::Type].should == "weapon"
        ammo = weapon["ammunition"]
        ammo[Tokens::Type].should == "ammunition"
      end

    end
  end
  
end
