require_relative '../lib/codiphi.rb'

def read_json(path)
  data = ""
  json_path = "#{BASE_PATH}lists/#{path}"
  f = File.open(json_path, "r")
  f.each_line do |line|
      data += line
  end
  JSON.parse(data)
end