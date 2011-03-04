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
end
