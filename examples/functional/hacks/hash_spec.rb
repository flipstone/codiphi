require_relative '../../spec_helper.rb'

describe Hash do 
  it "detects if Codiphi named type" do
    somehash = {
      Codiphi::Tokens::Name => "foo", 
      Codiphi::Tokens::Type => "bar"
    }
    
    somehash.should be_is_named_type("foo", "bar")
    
  end
end