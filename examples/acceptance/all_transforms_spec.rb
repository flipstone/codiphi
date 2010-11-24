require_relative './spec_helper.rb'

Dir["#{BASE_PATH}samples/lists/test/*.json"].each do |file|
  
  describe "acceptance suite" do

    file_ref = File.basename(file, ".json")
  
    it "passes #{file_ref}" do
      data = Codiphi::Support.read_json(file)
      engine = Codiphi::Engine.new(data)
      engine.run_transform
          
      expected_data = read_sample_json("test/expected/#{file_ref}-transform.json")
      engine.transformed_data.should set_match expected_data
    end      
  end

end