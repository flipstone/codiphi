require_relative './codiphi_node'
module Codiphi
  class CostMeasureAssignmentNode < AssignmentNode
    def gather_declarations(namespace, errors)
      # used without declaration, so add to namespace here.

      # raise error if previously declared with a different value
      [namespace, errors]
    end
  end
end
