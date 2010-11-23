require_relative './spec_helper.rb'

describe "test/hero1a" do
  describe "transform" do
    it "performs completion" do
      data = read_sample_json("test/hero1a.json")
      engine = Codiphi::Engine.new(data)
      engine.run_transform
            
      expected_data = read_sample_json("test/hero1a-expected.json")
      engine.transformed_data.should set_match expected_data
    end
  end

  describe "cost" do
    it "calculates correctly" do
      data = read_sample_json("test/hero1a.json")
      engine = Codiphi::Engine.new(data)
      engine.cost.should == 100
    end
  end
      
end
