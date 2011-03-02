module Codiphi
  module HashExtensions
    def is_named_type?(name, type)
      name == self[Tokens::Name] && 
      type == self[Tokens::Type] 
    end

    def named_type_values
      return self[Tokens::Name], self[Tokens::Type] 
    end

    def add_named_type(name, type)
      merge type => {
        Tokens::Name => name,
        Tokens::Type => type
      }
    end

    def is_list_node?
      self[Tokens::Type] == Tokens::List
    end

    def has_count?
      self.keys.include?(Tokens::Count)
    end

    def count_value
      Integer(self[Tokens::Count])
    end

    def has_cost?
      self.keys.include?(Tokens::Cost)
    end

    def set_cost(cost)
      merge Tokens::Cost => cost
    end

    def set_cost_by_operation(delta, token)
      merge Tokens::Cost => (token == Tokens::Removal ? -delta : delta)
    end

    def cost_value
      self[Tokens::Cost]
    end

  end
end

class Hash
  include Codiphi::HashExtensions
end
