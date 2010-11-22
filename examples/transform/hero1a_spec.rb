require_relative '../spec_helper.rb'

describe "test/hero1a" do
  describe "transform" do
    it "attaches children to matching data nodes" do
      tree = Codiphi::Parser.parse read_codex("hero1/hero1.cdx")
      data = read_json("test/one_man_army.json")

      tree.transform(data, Hash.new)
      data["list"]["model"].keys.should be_include "type"
      data["list"]["model"].keys.should be_include "cost"
      data["list"]["model"]["cost"].should == 100

    end

    xit "overwrites children on matched data nodes" do
    end

  end
      
end
