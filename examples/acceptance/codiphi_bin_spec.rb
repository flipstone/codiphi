require_relative 'spec_helper.rb'

Dir["#{BASE_PATH}samples/lists/test/*.yml"].each do |file|
  describe "bin/codiphi" do
    file_ref = File.basename(file, ".yml")

    it "doesn't fail against #{file_ref}" do
      output = %x{#{BASE_PATH}/bin/codiphi '#{file}' 2>&1}
      $?.should be_success, output
    end
  end
end
