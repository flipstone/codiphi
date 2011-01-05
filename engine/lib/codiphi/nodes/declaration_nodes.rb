require_relative './codiphi_node'

module Codiphi
  class DeclarationNode < CodiphiNode
    def gather_declarations(namespace)
      super(namespace)
      namespace.add_named_type(name_val, type_val)
    end
      
    def declarative?
      true
    end
  
    def name_val 
      name.text_value
    end

    def type_val
      type.text_value
    end  
  end

  class DeclarationListNode < CodiphiNode
  end

  class DeclarationBlockNode < CodiphiNode
  end
end