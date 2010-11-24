module Codiphi
  module Support
    
    def self.read_json(path)
      data = ""
      f = File.open(path, "r")
      f.each_line do |line|
          data += line
      end
      JSON.parse(data)
    end

    def self.read_schematic(path)
      data = ""
      codex_name = path.split('/').last
      full_path = "samples/schematics/#{path}/#{codex_name}.cdx"
      say "reading schematic at #{full_path}" do
        f = File.open(full_path, "r")
        f.each_line do |line|
            data += line
        end
      end
      data
    end
    
  end
end