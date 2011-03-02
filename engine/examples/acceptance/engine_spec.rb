require_relative 'spec_helper.rb'
ONLY = "ONLY"

Dir["#{BASE_PATH}samples/lists/test/*.yml"].each do |file|
  next if file =~ /transform|validate/
  describe Codiphi::Engine do
    file_ref = File.basename(file, ".yml")
    if ENV[ONLY].nil? || ENV[ONLY] == file_ref

      it "transforms #{file_ref}" do
        data = Codiphi::Support.read_yaml(file)
        e = Codiphi::Engine.new(data, validate: false)
        expected_data = read_sample_yaml("test/#{file_ref}-transform.yml")
        e.emitted_data.should set_match expected_data
      end

      it "repeatedly transforms to input #{file_ref}" do
        data = Codiphi::Support.read_yaml(file)
        e1 = Codiphi::Engine.new(data, validate: false)
        e2 = Codiphi::Engine.new(e1.emitted_data, validate: false)
        expected_data = read_sample_yaml("test/#{file_ref}-transform.yml")
        e2.emitted_data.should set_match expected_data
      end

      it "validates #{file_ref}" do
        data = Codiphi::Support.read_yaml(file)
        e = Codiphi::Engine.new(data)
        expected_data = read_sample_yaml("test/#{file_ref}-validate.yml")
        e.emitted_data.should set_match expected_data
      end

      it "doesn't modify input from #{file_ref}" do
        data = Codiphi::Support.read_yaml(file)
        Codiphi::Engine.new(data).emitted_data
        data.should == Codiphi::Support.read_yaml(file)
      end
    end
  end

end
