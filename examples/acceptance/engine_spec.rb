require_relative 'spec_helper.rb'
ONLY = "ONLY"

Dir["#{BASE_PATH}samples/lists/test/*.yml"].each do |file|

  describe Codiphi::Engine do
    file_ref = File.basename(file, ".yml")
    if ENV[ONLY].nil? || ENV[ONLY] == file_ref
    
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

end