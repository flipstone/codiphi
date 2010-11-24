require_relative './codiphi_node.rb'

class AssertionNode < CodiphiNode
  def gather_assertions(assertion_list)
    assertion_list = [] if assertion_list.nil?
    assertion_list << self
  end
end