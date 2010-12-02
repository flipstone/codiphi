require_relative './codiphi_node'

class CostMeasureAssignmentNode < AssignmentNode
  def gather_declarations(namespace)
    # used without declaration, so add to namespace here.
    
    # raise error if previously declared with a different value
  end
  
end

