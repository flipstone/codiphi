require_relative './codiphi_node'

class CodexNode < CodiphiNode
  def validate(json_document)
    json_document["list"].should_not == nil
    log %{validating json list "#{json_document['list']['description']}"}

    log_ok  
  end
  
  def validate_type(json_node)
    
  end
end