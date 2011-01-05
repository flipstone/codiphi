require_relative './codiphi_node'
module Codiphi
  class AssignmentNode < CodiphiNode
    def gather_declarations(namespace)
      unless namespace.named_type?(value_val, type_val)
        namespace.add_error(NoSuchNameException.new(self))
      end
    end

    def op_val 
      assignment_operator.text_value
    end

    def value_val 
      value.text_value
    end
    
    def type_val
      type.text_value
    end
    
    def completion_transform(data, namespace)
      super(data, namespace)
      match_node = parent_declaration_node
      
      if (match_node.nil?)
        warn "no target for assignment #{type.text_value} #{value.text_value}"
      else
        Traverse.matching_named_type(
          data, 
          match_node.name.text_value, 
          match_node.type.text_value
        ) { |target_hash| _do_completion(target_hash, namespace) }
      end
    end

    def _do_completion(target_hash, namespace)
      case assignment_operator.text_value
        when Tokens::Removal then
          _do_removal(target_hash)
        else
          _do_assignment(target_hash, namespace)
      end
    end
    
    def _do_assignment(target_hash, namespace)
      say _descriptive_string_for_hash(target_hash,"placing")

      if namespace.is_named_type?(value_val, type_val)
        target_hash.add_named_type(value_val, type_val)
      else
        target_hash[type_val] = value_val
      end
    end

    def _do_removal(target_hash)
      say _descriptive_string_for_hash(target_hash,"removing")
      
      child = target_hash[type_val]
      
      case child
        when Array then
          child.delete_if { |child_element|
            child_element.is_named_type?(value_val, type_val)
          }
        when Hash then 
          if child.is_named_type?(value_val, type_val)
            target_hash.delete(type_val) 
          end
      end
    end

    def _descriptive_string_for_hash(target_hash, verb_to_use)
      match_type = target_hash[Tokens::Type]
      match_name = target_hash[Tokens::Name]
      "#{verb_to_use} #{type_val} #{value_val} on #{match_type} :#{match_name}"
    end
    
  end
end
