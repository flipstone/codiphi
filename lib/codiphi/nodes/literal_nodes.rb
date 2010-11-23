require_relative './codiphi_node.rb'

class LiteralNode < CodiphiNode
end

class TypeNode < CodiphiNode
end

class IntegerNode < CodiphiNode
  def text_value
    super.to_i
  end
end

class NameNode < CodiphiNode
  def text_value
    super.reverse.chop.reverse
  end
end

class SpaceNode < LiteralNode
end