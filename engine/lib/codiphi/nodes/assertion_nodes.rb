require_relative './codiphi_node.rb'
module Codiphi
  class AssertionNode < CodiphiNode
  
    def gather_declarations(namespace)
      unless namespace.named_type?(name_val, type_val)
        namespace.add_error(Codiphi::NoSuchNameException.new(self)) 
      end
    end

    def gather_assertions(assertion_list)
      assertion_list = [] if assertion_list.nil?
      assertion_list << self
    end

    def op_val
      assertion_operator.text_value
    end

    def integer_val
      integer.text_value
    end

    def name_val 
      name.text_value
    end
    
    def type_val
      type.text_value
    end

  end
end