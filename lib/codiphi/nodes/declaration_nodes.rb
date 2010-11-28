require_relative './codiphi_node'

class DeclarationNode < CodiphiNode
  def gather_declarations(namespace)
    super(namespace)
    namespace[name.text_value] = type.text_value
  end
      
  def declarative?
    true
  end
  
end

class DeclarationListNode < CodiphiNode
end

class DeclarationBlockNode < CodiphiNode
end
