module Codiphi
  module Support
    include R18n::Helpers

    def self.recurseable?(v)
      v.is_a?(Hash) || v.is_a?(Array)
    end

    def self.read_file(path)
      data = ""
      File.open(path, 'r') do |f|
        f.each_line do |line|
          data += line
        end
      end
      data
    end

    def self.read_json(path)
      JSON.parse(read_file(path))
    end

    def self.read_yaml(path)
      YAML::load(read_file(path))
    end

    def self.read_schematic(url)
      full_path = "samples/schematics/#{url}.cdx"
      read_schematic_data(full_path)
    end

    def self.read_schematic_data(full_path)
      say t.bin.schematic(full_path)
      read_file(full_path)
    end

  end
end
