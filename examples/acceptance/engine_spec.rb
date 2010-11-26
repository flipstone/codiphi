require_relative './spec_helper.rb'

Dir["#{BASE_PATH}samples/lists/test/*.json"].each do |file|
  
  describe "engine" do
    file_ref = File.basename(file, ".json")
  
    it "transforms #{file_ref}" do
      data = Codiphi::Support.read_json(file)
      engine = Codiphi::Engine.new(data)
      engine.transform
      expected_data = read_sample_json("test/expected/#{file_ref}-transform.json")
      JSON.parse(engine.emitted_data).should set_match expected_data
    end

    it "validates #{file_ref}" do
      data = Codiphi::Support.read_json(file)
      engine = Codiphi::Engine.new(data)
      engine.transform
      engine.validate
      expected_data = read_sample_json("test/expected/#{file_ref}-validate.json")
      JSON.parse(engine.emitted_data).should set_match expected_data
    end      
  end

end