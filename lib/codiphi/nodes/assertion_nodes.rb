require_relative './codiphi_node.rb'
module Codiphi
  class AssertionNode < CodiphiNode
  
    def gather_declarations(namespace)
      unless namespace.named_type?(name.text_value, type.text_value)
        namespace.add_error(Codiphi::NoSuchNameException.new(self)) 
      end
    end

    def gather_assertions(assertion_list)
      assertion_list = [] if assertion_list.nil?
      assertion_list << self
    end
  end
end