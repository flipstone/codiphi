require_relative './codiphi_node'

class DeclarationNode < CodiphiNode
  def transform(data, context)
    super(data,context)
    match_node = parent_declaration_node
    
    if (match_node.nil?)
      # has no parent declaration, don't do anything just now.
    else
      match_type = match_node.type.text_value
      match_name = match_node.declared.text_value
      say "placing #{type.text_value} #{declared.text_value} on matching #{match_type} #{match_name} nodes" do
        # find match_node in data
        traverse_data_for_match(data, match_type, match_name) do |target_hash|
          target_hash[type.text_value] = declared.text_value
        end
      end      
    end
  end
      
  def declarative?
    true
  end
  
end

class DeclarationListNode < CodiphiNode
end

class DeclarationBlockNode < CodiphiNode
end
