module Codiphi
  module Support
    include R18n::Helpers
    CanonicalKeys = [Tokens::Type]
        
    def self.expand_to_canonical(input, namespace, schematic_type=nil)
      case input
      when Hash then
        input[Tokens::Type] = schematic_type unless schematic_type.nil?
        input.each do |k,v|
          if namespace.declared_type?(k) && !([Array, Hash].include?(v.class))
            input.add_named_type(v, k)
          end

          expand_to_canonical(v, namespace, k) if [Hash, Array].include?(v.class)
        end
      when Array then
        input.each do |v|
          expand_to_canonical(v, namespace, schematic_type) if [Hash, Array].include?(v.class)
        end
      end
    end
    
    def self.remove_canonical_keys(input)
      case input
      when Hash then
        input.each do |k,v|
        if (CanonicalKeys.include?(k))
          input.delete(k)
        end
        remove_canonical_keys(v) if [Hash, Array].include?(v.class)
        end
      when Array then
        input.each do |v|
          remove_canonical_keys(v) if [Hash, Array].include?(v.class)
        end
      end
    end
    
    def self.read_json(path)
      data = ""
      f = File.open(path, 'r')
      f.each_line do |line|
          data += line
      end
      JSON.parse(data)
    end

    def self.read_yaml(path)
      data = ""
      f = File.open(path, 'r')
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