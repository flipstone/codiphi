require_relative '../spec_helper.rb'

Treetop.load File.join(BASE_PATH, "lib/codiphi")

RSpec::Matchers.define :parse do |a_string|
  match do |parser|
    !parser.parse(a_string).nil?
  end
  failure_message_for_should do |parser|
    "Unable to parse expected legal input.\n#{parser.failure_reason}" 
  end
  failure_message_for_should_not do |parser|
    "Incorrectly parsed expected illegal input." 
  end
end

def read_codex(path)
  data = ""
  full_path = "schematics/test/#{path}"
  f = File.open(full_path, "r")
  f.each_line do |line|
      data += line
  end
  data
end