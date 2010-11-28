require_relative './codiphi_node'

class AssignmentNode < CodiphiNode
  
  def completion_transform(data, namespace)
    super(data, namespace)

    # sc: todo: verify that assignment is legal

    match_node = parent_declaration_node
    
    if (match_node.nil?)
      # has no parent declaration, don't do anything just now.
      say "no parent for declaration #{type.text_value} #{value.text_value}"
    else
      match_type = match_node.type.text_value
      match_name = match_node.name.text_value
      say_ok "placing #{type.text_value} #{value.text_value} on matching #{match_type} #{match_name} nodes" do
        # find match_node in data
        Codiphi::Traverse.matching_named_type(data, match_type, match_name, 0) do |target_hash|
          target_hash[type.text_value] = value.text_value
        end
      end      
    end
  end
end

