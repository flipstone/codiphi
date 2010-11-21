require_relative './codiphi_node.rb'

class CodexNode < CodiphiNode

  def emit(data)
    declaration_list.emit(data)
    list.emit(data)
  end

end