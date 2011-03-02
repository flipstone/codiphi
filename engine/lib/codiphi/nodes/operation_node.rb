require_relative './codiphi_node.rb'

module Codiphi
  class OperationNode < CodiphiNode
    def evaluate
      right_operand.left_associative_evaluate(left_operand.evaluate, operator)
    end

    def left_associative_evaluate(left_assoc_value, left_operator)
      if left_operator.precedence >= operator.precedence
        right_operand.left_associative_evaluate(
          left_operator.operate(left_assoc_value, left_operand.evaluate),
          operator
        )
      else
        left_operator.operate(left_assoc_value, evaluate)
      end
    end
  end

  class AdditionNode < CodiphiNode
    def operate(left_operand, right_operand)
      left_operand + right_operand
    end

    def precedence
      1
    end
  end

  class SubtractionNode < CodiphiNode
    def operate(left_operand, right_operand)
      left_operand - right_operand
    end

    def precedence
      1
    end
  end

  class MultiplicationNode < CodiphiNode
    def operate(left_operand, right_operand)
      left_operand * right_operand
    end

    def precedence
      2
    end
  end

  class DivisionNode < CodiphiNode
    def operate(left_operand, right_operand)
      left_operand / right_operand
    end

    def precedence
      2
    end
  end

  class ParentheticalNode < CodiphiNode
    def evaluate
      formula.evaluate
    end

    def left_associative_evaluate(left_assoc_value, left_operator)
      left_operator.operate(left_assoc_value, evaluate)
    end
  end
end
