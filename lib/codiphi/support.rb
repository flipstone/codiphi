module Codiphi
  module Support
    include R18n::Helpers
    
    def self.read_json(path)
      data = ""
      f = File.open(path, "r")
      f.each_line do |line|
          data += line
      end
      JSON.parse(data)
    end

    def self.read_yaml(path)
      data = ""
      f = File.open(path, "r")
      f.each_line do |line|
          data += line
      end
      YAML::load(data)
    end

    def self.read_schematic(url)
      data = ""
      codex_name = url.split('/').last
      full_path = "samples/schematics/#{url}/#{codex_name}.cdx"
      say_ok t.bin.schematic(full_path) do
        f = File.open(full_path, "r")
        f.each_line do |line|
            data += line
        end
      end
      data
    end
    
  end
end