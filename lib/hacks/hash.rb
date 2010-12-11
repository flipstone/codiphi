module Codiphi
  module HashExtensions
    def is_named_type?(name, type)
      name == self[SchematicNameKey] && 
      type == self[SchematicTypeKey] 
    end

    def is_list_node?
      self[SchematicTypeKey] == SchematicListKey
    end

    def add_to_cost(delta)
      self[SchematicCostKey] ||= 0
      self[SchematicCostKey] += delta
    end
  end
end

class Hash
  include Codiphi::HashExtensions
end
