require_relative './codiphi_node.rb'

class AssertionNode < CodiphiNode
  def transform(data, context)
    context["assertions"] = [] if context["assertions"].nil?
    context["assertions"] << self
  end
end