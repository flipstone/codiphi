module Codiphi
  module HashExtensions
    def is_named_type?(name, type)
      name == self[Tokens::Name] && 
      type == self[Tokens::Type] 
    end

    def add_named_type(name, type)
      self[type] = new_child = Hash.new
      new_child[Tokens::Name] = name
      new_child[Tokens::Type] = type
    end
    
    def is_list_node?
      self[Tokens::Type] == Tokens::List
    end

    def add_to_cost(delta, token)
      self[Tokens::Cost] ||= 0
      case token
        when Tokens::Assignment
          self[Tokens::Cost] += delta
        when Tokens::Removal
          self[Tokens::Cost] -= delta
        else
          self[Tokens::Cost] = delta
      end
    end
    
    def has_count?
      self.keys.include?(Tokens::Count)
    end

    def count_value
      self[Tokens::Count]
    end

    def has_cost?
      self.keys.include?(Tokens::Cost)
    end

    def cost_value
      self[Tokens::Cost]
    end

  end
end

class Hash
  include Codiphi::HashExtensions
end
