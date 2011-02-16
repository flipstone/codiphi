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

  it "adds error" do
    x = RuntimeError.new
    n = Codiphi::Namespace.new.add_error(x)
    n.should have_errors
    n.errors.should include(x)
  end

  it "clears errors" do
    x = RuntimeError.new
    n = Codiphi::Namespace.new.add_error(x).clear_errors
    n.errors.should be_nil
    n.should_not have_errors
  end

  it "is frozen" do
    Codiphi::Namespace.new.should be_frozen
  end

  it "is frozen after adding error" do
    Codiphi::Namespace.new.add_error("foo").should be_frozen
  end
end
