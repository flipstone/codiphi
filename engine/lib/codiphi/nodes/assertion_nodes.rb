require_relative './codiphi_node.rb'
module Codiphi
  class AssertionNode < CodiphiNode

    def gather_declarations(namespace, errors)
      if namespace.named_type?(name_val, type_val)
        [namespace, errors]
      else
        [namespace, errors + [Codiphi::NoSuchNameException.new(self)]]
      end
    end

    def gather_assertions(data, assertion_list)
      [data, assertion_list + [self]]
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
