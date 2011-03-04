require_relative './codiphi_node.rb'

module Codiphi
  class OperationNode < CodiphiNode
    def evaluate(context)
      if right_operand.respond_to?(:left_associative_evaluate)
        right_operand.left_associative_evaluate(
          left_operand.evaluate(context), operator, context
        )
      else
        operator.operate left_operand.evaluate(context),
                         right_operand.evaluate(context)
      end
    end

    def left_associative_evaluate(left_assoc_value, left_operator, context)
      if left_operator.precedence >= operator.precedence
        if right_operand.respond_to?(:left_associative_evaluate)
          right_operand.left_associative_evaluate(
            left_operator.operate(left_assoc_value,
                                  left_operand.evaluate(context)),
            operator,
            context
          )
        else
          operator.operate(
            left_operator.operate(left_assoc_value, left_operand.evaluate(context)),
            right_operand.evaluate(context))
        end
      else
        left_operator.operate left_assoc_value, evaluate(context)
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
    def evaluate(context)
      formula.evaluate context
    end
  end

  class FunctionReferenceNode < CodiphiNode
    def evaluate(context)
      context[function_name.text_value.to_sym].call argument.text_value
    end
  end
end
