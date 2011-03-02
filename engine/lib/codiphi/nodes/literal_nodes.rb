require_relative './codiphi_node.rb'
module Codiphi

  class LiteralNode < CodiphiNode
  end

  class TypeNode < CodiphiNode
  end

  class IntegerNode < CodiphiNode
    def text_value
      super.to_i
    end

    def evaluate
      text_value
    end

    def left_associative_evaluate(left_assoc_value, operator)
      operator.operate(left_assoc_value, evaluate)
    end
  end

  class NameNode < CodiphiNode
    def text_value
      super.reverse.chop.reverse
    end
  end
end
