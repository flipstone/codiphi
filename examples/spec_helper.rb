require_relative '../lib/codiphi.rb'

SayLogging.suppress_log

def read_sample_json(path)
  data = ""
  json_path = "#{BASE_PATH}lists/#{path}"
  Codiphi::Support.read_json(json_path)
end