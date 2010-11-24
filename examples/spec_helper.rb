require_relative '../lib/codiphi.rb'
require 'mocha'

SayLogging.suppress_log

def read_sample_json(path)
  data = ""
  json_path = "#{BASE_PATH}samples/lists/#{path}"
  Codiphi::Support.read_json(json_path)
end