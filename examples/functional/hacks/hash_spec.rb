require_relative '../../spec_helper.rb'

describe Hash do 
  it "detects if Codiphi named type" do
    somehash = {
      Codiphi::SchematicNameKey => "foo", 
      Codiphi::SchematicTypeKey => "bar"
    }
    
    somehash.should be_is_named_type("foo", "bar")
    
  end
end