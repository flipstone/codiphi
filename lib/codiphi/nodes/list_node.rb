require_relative './codiphi_node.rb'

class ListNode < CodiphiNode
  def declarative?
    true
  end

  def name
    type
  end

end

class ListAssertionBlockNode < CodiphiNode
end