require_relative './codiphi_node.rb'

class LiteralNode < CodiphiNode
  def emit(data)
    text_value
  end
end

class IntegerNode < CodiphiNode
  def emit(data)
    text_value
  end
end