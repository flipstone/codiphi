require_relative '../lib/codiphi.rb'
require 'mocha'
require_relative 'support/all'

SayLogging.suppress_log

def read_sample_json(path)
  data = ""
  json_path = "#{BASE_PATH}samples/lists/#{path}"
  Codiphi::Support.read_json(json_path)
end

def read_sample_yaml(path)
  data = ""
  yaml_path = "#{BASE_PATH}samples/lists/#{path}"
  Codiphi::Support.read_yaml(yaml_path)
end
