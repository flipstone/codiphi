require_relative '../spec_helper.rb'

describe Codiphi::Namespace do

  it "adds_named_type" do
    n = Codiphi::Namespace.new
    n.add_named_type("foo", "unit")
    n["foo"].should_not be_nil
    n.should be_named_type("foo", "unit")
  end

  it "supports multiple types for name" do
    n = Codiphi::Namespace.new
    n.add_named_type("foo", "unit")
    n.add_named_type("foo", "quarzle")
    n.should be_named_type("foo", "unit")
    n.should be_named_type("foo", "quarzle")
    n.should_not be_named_type("foo", "zingbat")
  end

  
  it "adds error" do
    n = Codiphi::Namespace.new
    x = RuntimeError.new
    n.add_error(x)
    n.errors.should include(x)
    n.should have_errors
  end
end