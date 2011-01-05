require_relative './codiphi_node'
module Codiphi
  class ConditionNode < CodiphiNode
    def gather_assertions(data, namespace, assertion_list, enclosing_condition)
      # find my parent in data
      match_node = parent_declaration_node
      my_result = false

      if (match_node.nil?)
        warn "no wrapping declaration for assignment #{type.text_value} #{name.text_value}"
      else        
        Traverse.matching_named_type(
          data, 
          match_node.name.text_value, 
          match_node.type.text_value
        ) do |target_hash| 
            # check for presence of my named type
            my_result = _check_presence_in(target_hash)
          end
      end
            
      # recurse to children with result of condition
      recurse_to_children(:gather_assertions, 
        [data, namespace, assertion_list, my_result])
    end

    def _check_presence_in(target_hash)
      target_hash.values.each do |value|
        present = value.is_named_type?(name_val, type_val) if value.class == Hash
        return true if present
      end
      false
    end

    def op_val
      assertion_operator.text_value
    end

    def name_val 
      name.text_value
    end
    
    def type_val
      type.text_value
    end

  end
end
