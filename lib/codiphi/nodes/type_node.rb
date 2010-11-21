require_relative './codiphi_node.rb'

class TypeNode < CodiphiNode
  def emit(data)
    text_value
  end
end