require_relative './codiphi_node'

class DeclarationListNode < CodiphiNode

  def emit(list)
    declaration.emit(list)
  end

end