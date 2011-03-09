require_relative '../../spec_helper.rb'

describe Hash do
  it "detects if Codiphi named type" do
    somehash = {
      Codiphi::Tokens::Name => "foo",
      Codiphi::Tokens::Type => "bar"
    }

    somehash.should be_is_named_type("foo", "bar")

  end

  describe "count_value" do
    it "returns the value of 'count'" do
      {'count' => 2}.count_value.should == 2
    end

    it "returns the value of 'count' as integer if it is a string" do
      {'count' => '2'}.count_value.should == 2
    end

    it "raises an error if count is not a valid number" do
      lambda do
        {'count' => 'ambd'}.count_value
      end.should raise_error
    end
  end

  describe "cost_value" do
    it "returns an uncallable value that was set" do
      {}.set_cost(13).cost_value.should == 13
    end
  end

  describe "add_named_type" do
    it "adds a single node" do
      {}.add_named_type("foo","bar")["bar"]
      .named_type_values.should == ["foo", "bar"]
    end

    it "converts to array on adding second node" do
      bar = {}.add_named_type("foo","bar")
              .add_named_type("baz","bar")["bar"]
      bar.map(&:named_type_values).should == [
        ["foo","bar"],
        ["baz","bar"]
      ]
    end

    it "keeps adding to array on adding third node" do
      bar = {}.add_named_type("foo","bar")
              .add_named_type("baz","bar")
              .add_named_type("bat","bar")["bar"]
      bar.map(&:named_type_values).should == [
        ["foo","bar"],
        ["baz","bar"],
        ["bat","bar"]
      ]
    end
  end
end
