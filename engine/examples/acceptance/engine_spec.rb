require_relative 'spec_helper.rb'
ONLY = "ONLY"

Dir["#{BASE_PATH}samples/lists/test/*.yml"].each do |file|

  describe Codiphi::Engine do
    file_ref = File.basename(file, ".yml")
    if ENV[ONLY].nil? || ENV[ONLY] == file_ref

      it "transforms #{file_ref}" do
        data = Codiphi::Support.read_yaml(file)
        e1 = Codiphi::Engine.new(data)
        e2 = e1.completion_transform
        expected_data = read_sample_yaml("test/expected/#{file_ref}-transform.yml")
        e2.emitted_data.should set_match expected_data
      end

      it "repeatedly transforms to input #{file_ref}" do
        data = Codiphi::Support.read_yaml(file)
        e1 = Codiphi::Engine.new(data)
        e2 = e1.completion_transform
        e3 = e2.completion_transform
        expected_data = read_sample_yaml("test/expected/#{file_ref}-transform.yml")
        e3.emitted_data.should set_match expected_data
      end

      it "validates #{file_ref}" do
        data = Codiphi::Support.read_yaml(file)
        e1 = Codiphi::Engine.new(data)
        e2 = e1.completion_transform
        e3 = e2.validate
        expected_data = read_sample_yaml("test/expected/#{file_ref}-validate.yml")
        e3.emitted_data.should set_match expected_data
      end

      it "doesn't modify input from #{file_ref}" do
        data = Codiphi::Support.read_yaml(file)
        Codiphi::Engine.new(data).completion_transform.validate
        data.should == Codiphi::Support.read_yaml(file)
      end

      it "doesn't re-use output from previous-step from #{file_ref}" do
        data = Codiphi::Support.read_yaml(file)
        e1 = Codiphi::Engine.new(data)
        e2 = e1.completion_transform
        e3 = e2.validate
        expected_data = read_sample_yaml("test/expected/#{file_ref}-validate.yml")
        (e3.emitted_data == e2.emitted_data).should == (e2.emitted_data == expected_data)
      end

    end
  end

end
