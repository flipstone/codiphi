bin_path = File.expand_path(File.dirname(__FILE__))
BASE_PATH = File.join(bin_path, '../')

require 'polyglot'
require 'treetop'
require 'json'
Dir["#{BASE_PATH}lib/models/*.rb"].each {|file| require file }

CodiphiNode.suppress_log

def read_json(path)
  data = ""
  json_path = "#{BASE_PATH}lists/#{path}"
  f = File.open(json_path, "r")
  f.each_line do |line|
      data += line
  end
  JSON.parse(data)
end