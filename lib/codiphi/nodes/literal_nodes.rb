require_relative './codiphi_node.rb'

class LiteralNode < CodiphiNode
  def emit(data)
    # do nothing with literals
  end
end

class TypeNode < CodiphiNode
  def emit(data)
    text_value
  end
end

class IntegerNode < CodiphiNode
end

class NameNode < CodiphiNode
end

class SpaceNode < LiteralNode
  def to_s
  end
end