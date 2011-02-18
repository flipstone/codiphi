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

    def add_to_cost(delta, token, force=false)
      cost = self[Tokens::Cost] || 0

      if force
        delta = -delta if token == Tokens::Removal
        cost = delta
      else
        case token
        when Tokens::Addition
          cost += delta
        when Tokens::Removal
          cost -= delta
        when Tokens::Assignment
          cost = delta
        else
          cost
        end
      end

      merge Tokens::Cost => cost
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

    def cost_value
      self[Tokens::Cost]
    end

  end
end

class Hash
  include Codiphi::HashExtensions
end
