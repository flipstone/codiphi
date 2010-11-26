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

    def self.read_schematic(url)
      data = ""
      codex_name = url.split('/').last
      full_path = "samples/schematics/#{url}/#{codex_name}.cdx"
      say_ok "reading schematic at #{full_path}" do
        f = File.open(full_path, "r")
        f.each_line do |line|
            data += line
        end
      end
      data
    end
    
  end
end