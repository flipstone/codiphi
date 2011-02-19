require_relative '../spec_helper.rb'

describe Codiphi::Namespace do
  it "adds_named_type" do
    n = Codiphi::Namespace.new.add_named_type("foo", "unit")
    n["foo"].should_not be_nil
    n.should be_declared_type("unit")
    n.should be_named_type("foo", "unit")
  end

  it "supports multiple types for name" do
    n = Codiphi::Namespace.new
        .add_named_type("foo", "unit")
        .add_named_type("foo", "quarzle")

    n.should be_named_type("foo", "unit")
    n.should be_named_type("foo", "quarzle")
    n.should_not be_named_type("foo", "zingbat")
  end

  it "is frozen" do
    Codiphi::Namespace.new.should be_frozen
  end

  it "is frozen after adding type" do
    Codiphi::Namespace.new.add_named_type("foo", "unit").should be_frozen
  end
end
