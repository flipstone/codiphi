require_relative './codiphi_node.rb'
module Codiphi
  class AssertionNode < CodiphiNode

    def gather_declarations(namespace, errors)
      name_vals.inject([namespace, errors]) do |(namespace, errors), name_val|
        if namespace.named_type?(name_val, type_val)
          [namespace, errors]
        else
          [namespace, errors + [Codiphi::NoSuchNameException.new(name_val, type_val)]]
        end
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

    def name_vals
      name.respond_to?(:name_values) ?
        name.name_values :
        [name_val]
    end

    def type_val
      type.text_value
    end

    def named_type_values
      return name_val, type_val
    end
  end
end
