require_relative './codiphi_node.rb'

class CostMeasureNode < CodiphiNode
  def emit(list)
    declaration.process(list)
  end
end