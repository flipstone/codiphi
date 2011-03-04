require_relative 'spec_helper.rb'

describe Codiphi::Parser, "option_list" do
  it "parses list of one name" do
    Node(:option_list, "[:foo]")
    .name_values.should == %w(foo)
  end
  it "parses list of names" do
    Node(:option_list, "[:foo :bar :baz :bat]")
    .name_values.should == %w(foo bar baz bat)
  end
end
