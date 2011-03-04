require_relative './codiphi_node'

module Codiphi
  class CostAssignmentNode < CodiphiNode

    def op_val
      assignment_operator.text_value
    end

    def value_val
      value.text_value
    end

    def type_val
      type.text_value
    end

    def completion_transform(data, namespace)
      super(data, namespace)

      match_node = parent_declaration_node

      if (match_node.nil?)
        # has no parent declaration, don't do anything just now.
        warn "no parent for assignment of cost #{value_val}"
        [data, namespace]
      else
        match_type = match_node.type_val
        match_name = match_node.name_val

        new_data = Transform.matching_named_type(data, match_name, match_type) do |target_hash|
          say "placing cost #{value_val} on #{match_type} #{match_name}"
          target_hash.set_cost(
            value.evaluate(Functions.curry_data(target_hash)) *
            (op_val == Tokens::Removal ? -1 : 1)
          )
        end

        [new_data, namespace]
      end
    end
  end
end
