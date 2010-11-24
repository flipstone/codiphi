require_relative './spec_helper.rb'

Dir["#{BASE_PATH}samples/lists/test/*.json"].each do |file|
  
  describe "acceptance suite" do

    file_ref = File.basename(file, ".json")
  
    it "transforms #{file_ref}" do
      data = Codiphi::Support.read_json(file)
      engine = Codiphi::Engine.new(data)
      engine.run_completeness_transform
      expected_data = read_sample_json("test/expected/#{file_ref}-transform.json")
    end

    it "validates #{file_ref}" do
      data = Codiphi::Support.read_json(file)
      engine = Codiphi::Engine.new(data)
      engine.run_assertions
      expected_data = read_sample_json("test/expected/#{file_ref}-validate.json")
      engine.transformed_data.should set_match expected_data
    end      
  end

end