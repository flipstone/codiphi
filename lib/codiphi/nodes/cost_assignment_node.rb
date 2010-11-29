require_relative './codiphi_node'

class CostAssignmentNode < CodiphiNode
  
  Token = "cost"
  
  def completion_transform(data, namespace)
    super(data, namespace)

    match_node = parent_declaration_node
    
    if (match_node.nil?)
      # has no parent declaration, don't do anything just now.
      say "no parent for assignment of cost #{value.text_value}"
    else
      match_type = match_node.type.text_value
      match_name = match_node.name.text_value
      say_ok "placing cost #{value.text_value} on matching #{match_type} #{match_name} nodes" do
        # find match_node in data
        Codiphi::Traverse.matching_named_type(data, match_type, match_name, 0) do |target_hash|
          if (target_hash.keys.include? (Token))
            target_hash[Token] += value.text_value
          else
            target_hash[Token] = value.text_value
          end
            
        end
      end      
    end
  end
end

