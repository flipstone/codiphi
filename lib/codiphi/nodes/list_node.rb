require_relative './codiphi_node.rb'

class ListNode < CodiphiNode
  def emit(data)
    declaration_block.emit(data)
  end
end

class ListPermissionBlockNode < CodiphiNode
  def emit(data)
  end
end