require_relative '../spec_helper.rb'

module Codiphi
  describe Support do
    describe "remove_canonical_keys" do
      it "works" do
        input = {
          "a" => "b",
          "c" => [
            {
              SchematicNameKey => "foo",
              SchematicTypeKey => "c"
            },
            {
              SchematicNameKey => "bar",
              SchematicTypeKey => "c"
            }]
        }
        
        Support.remove_canonical_keys(input)
        input["c"].each do |e|
          e.keys.should_not be_include(SchematicTypeKey)
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
        input["unit"][SchematicNameKey].should == "foo"
        input["unit"][SchematicTypeKey].should == "unit"
      end

      it "applies SchematicTypeKey to Hash" do
        input = {
          "a" => "b",
          "c" => {
            SchematicNameKey => "foo"
          }        
        }
      
        Support.expand_to_canonical(input, Namespace.new)
      
        input["a"].should == "b"
        input["c"].keys.should include(SchematicTypeKey)
        input["c"][SchematicTypeKey].should == "c"
      end

      it "applies SchematicTypeKey to Array of Hash" do
        input = {
          "a" => "b",
          "c" => [
            {
              SchematicNameKey => "foo"
            },
            {
              SchematicNameKey => "bar"
            }]
        }
      
        Support.expand_to_canonical(input,Namespace.new)
      
        input["a"].should == "b"
        input["c"].each do |e|
          e.keys.should include(SchematicTypeKey)
          e[SchematicTypeKey].should == "c"
        end
      end

      it "applies SchematicTypeKey to nested Hash" do
        input = {
          "a" => [
            {
              SchematicNameKey => "foo",
              "weapon" => {
                SchematicNameKey => "weapon_type",
                "ammunition" => {
                  SchematicNameKey => "hellfire_rounds"
                }
              }
            }]
        }
      
        Support.expand_to_canonical(input,Namespace.new)
      
        input["a"][0][SchematicTypeKey].should == "a"
        weapon = input["a"][0]["weapon"]
        weapon[SchematicTypeKey].should == "weapon"
        ammo = weapon["ammunition"]
        ammo[SchematicTypeKey].should == "ammunition"
      end

    end
  end
  
end