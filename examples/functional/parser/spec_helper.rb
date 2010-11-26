require_relative '../../spec_helper.rb'

RSpec::Matchers.define :parse do |a_string|
  match do |parser|
    begin
      success = !parser.parse(a_string).nil?
    rescue Codiphi::ParseException
      success = false
    end
    success
  end
  failure_message_for_should do |parser|
    "Unable to parse expected legal input.\n#{parser.failure_reason}" 
  end
  failure_message_for_should_not do |parser|
    "Incorrectly parsed expected illegal input." 
  end
end

def read_sample_codex(path)
  data = ""
  full_path = "samples/schematics/test/#{path}"
  f = File.open(full_path, "r")
  f.each_line do |line|
      data += line
  end
  data
end