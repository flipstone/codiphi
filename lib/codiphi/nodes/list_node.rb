require_relative './codiphi_node.rb'

class ListNode < CodiphiNode
  def declarative?
    true
  end

  def declared
    type
  end

end

class ListAssertionBlockNode < CodiphiNode
end