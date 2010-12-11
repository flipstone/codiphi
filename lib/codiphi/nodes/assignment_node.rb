require_relative './codiphi_node'
module Codiphi
  class AssignmentNode < CodiphiNode
    # any named type assigned should have been previously declared 
    # in the schematic
    def gather_declarations(namespace)
      goodtype = namespace.keys.include?(value.text_value) && 
                 namespace[value.text_value].include?(type.text_value)
      unless goodtype
        namespace.add_error(NoSuchNameException.new(self))
      end
    end
  
    def completion_transform(data, namespace)
      super(data, namespace)
      match_node = parent_declaration_node
      
      if (match_node.nil?)
        warn "no target for assignment #{type.text_value} #{value.text_value}"
      else
        Traverse.matching_named_type(
          data, 
          match_node.type.text_value, 
          match_node.name.text_value
        ) { |target_hash| _do_completion(target_hash, namespace) }
      end
    end

    def _do_completion(target_hash, namespace)
      case assignment_operator.text_value
        when Tokens::Assignment then
          _do_assignment(target_hash, namespace)
        when Tokens::Removal then
          _do_removal(target_hash)
      end
    end
    
    def _do_assignment(target_hash, namespace)
      say _descriptive_string_for_hash(target_hash,"placing")
      if namespace.is_named_type?(value.text_value, type.text_value)
        target_hash.add_named_type(value.text_value, type.text_value)
      else
        target_hash[type.text_value] = value.text_value
      end
    end

    def _do_removal(target_hash)
      say _descriptive_string_for_hash(target_hash,"removing")
      case target_hash[type.text_value]
        when Array then
          target_hash[type.text_value].delete_if { |child|
            child.is_named_type?(value.text_value, type.text_value)
          }
        when Hash then 
          if target_hash[type.text_value].is_named_type?(value.text_value, type.text_value)
            target_hash.delete(type.text_value) 
          end
      end
    end

    def _descriptive_string_for_hash(target_hash, verb_to_use)
      match_type = target_hash[Tokens::Type]
      match_name = target_hash[Tokens::Name]
      "#{verb_to_use} #{type.text_value} #{value.text_value} on #{match_type} :#{match_name}"
    end
    
  end
end
