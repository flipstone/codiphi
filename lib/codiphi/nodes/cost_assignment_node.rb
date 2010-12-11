require_relative './codiphi_node'

module Codiphi
  class CostAssignmentNode < CodiphiNode
  
    Token = "cost"
  
    def completion_transform(data, namespace)
      super(data, namespace)

      match_node = parent_declaration_node
    
      if (match_node.nil?)
        # has no parent declaration, don't do anything just now.
        warn "no parent for assignment of cost #{value.text_value}"
      else
        match_type = match_node.type.text_value
        match_name = match_node.name.text_value

        # find match_node in data
        delta = case assignment_operator.text_value
          when '+' then value.text_value
          when '-' then -(value.text_value)
          else value.text_value
        end
        Codiphi::Traverse.matching_named_type(data, match_type, match_name) do |target_hash|
          say "placing cost #{value.text_value} on #{target_hash.inspect}"
          if (target_hash.keys.include? (Token))
            target_hash[Token] += delta
          else
            target_hash[Token] = delta
          end
        end
      end
    end
  end
end