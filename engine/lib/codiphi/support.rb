module Codiphi
  module Support
    include R18n::Helpers
    CanonicalKeys = [Tokens::Type]

    def self.recurseable?(v)
      v.is_a?(Hash) || v.is_a?(Array)
    end

    def self.transform(*args)
      Transform.transform(*args)
    end

    def self.expand_to_canonical(data, namespace, schematic_type=nil)
      transform data,

                -> data do
                  unless schematic_type.nil?
                    data.merge Tokens::Type => schematic_type
                  end
                end,

                -> k,v do
                  if recurseable?(v)
                    expand_to_canonical(v, namespace, k)
                  elsif namespace.declared_type?(k)
                    { Tokens::Name => v, Tokens::Type => k }
                  else
                    v
                  end
                end
    end

    def self.remove_canonical_keys(data)
      transform data,

                -> data do
                  data.reject {|k,v| CanonicalKeys.include?(k) }
                end,

                -> k,v do
                  if recurseable?(v)
                    remove_canonical_keys(v)
                  else
                    v
                  end
                end
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
      codex_name = url.split('/').last
      full_path = "samples/schematics/#{url}/#{codex_name}.cdx"
      read_schematic_data(full_path)
    end

    def self.read_schematic_data(full_path)
      say t.bin.schematic(full_path)
      read_file(full_path)
    end

  end
end
