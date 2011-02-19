require_relative '../spec_helper.rb'

describe Codiphi::Engine do
  describe "validating?" do
    it "is true if validate option is not passed" do
      Codiphi::Engine.new({},{}).should be_validating
    end

    it "is true if validate option is not passedas true" do
      Codiphi::Engine.new({},validate: true).should be_validating
    end

    it "is false if validate option is passed as false" do
      Codiphi::Engine.new({},validate: false).should_not be_validating
    end
  end
end
