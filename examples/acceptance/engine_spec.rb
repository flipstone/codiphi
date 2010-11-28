require_relative './spec_helper.rb'

Dir["#{BASE_PATH}samples/lists/test/*.json"].each do |file|
  
  describe "engine" do
    file_ref = File.basename(file, ".json")
  
    it "transforms #{file_ref}" do
      data = Codiphi::Support.read_yaml(file)
      engine = Codiphi::Engine.new(data)
      engine.completion_transform
      expected_data = read_sample_yaml("test/expected/#{file_ref}-transform.yml")
      engine.emitted_data.should set_match expected_data
    end

    it "validates #{file_ref}" do
      data = Codiphi::Support.read_yaml(file)
      engine = Codiphi::Engine.new(data)
      engine.completion_transform
      engine.validate
      expected_data = read_sample_yaml("test/expected/#{file_ref}-validate.yml")
      engine.emitted_data.should set_match expected_data
    end      
  end

end