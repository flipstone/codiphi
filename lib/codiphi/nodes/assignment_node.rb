require_relative './codiphi_node'
module Codiphi
  class AssignmentNode < CodiphiNode
  
    # any named type assigned should have been previously declared 
    # in the schematic
    def gather_declarations(namespace)
      goodtype = namespace.keys.include?(value.text_value) && 
                 namespace[value.text_value].include?(type.text_value)
      unless goodtype
        namespace.add_error(Codiphi::NoSuchNameException.new(self))
      end
    end
  
    def completion_transform(data, namespace)
      super(data, namespace)

      match_node = parent_declaration_node
    
      if (match_node.nil?)
        # has no parent declaration, don't do anything just now.
        say "no parent for assignment #{type.text_value} #{value.text_value}"
      else
        match_type = match_node.type.text_value
        match_name = match_node.name.text_value
        # find match_node in data
        Codiphi::Traverse.matching_named_type(data, match_type, match_name, 0) do |target_hash|
          case assignment_operator.text_value
            when '+' then
              say "placing #{type.text_value} #{value.text_value} on #{match_type} :#{match_name}"
              target_hash[type.text_value] = value.text_value
              break
            when '-' then
              say "removing #{type.text_value} #{value.text_value} from #{match_type} :#{match_name}"
              # if array, remove just the one
              case target_hash[type.text_value]
              when Array then
                target_hash[type.text_value].delete_if { |child|
                  child.class == Hash && child["type"] == value.text_value
                }
              else 
                if target_hash[type.text_value] == value.text_value
                  target_hash.delete(type.text_value) 
                end
              end
            end
        end      
      end
    end
  end
end