require_relative './codiphi_node.rb'

class PermissionNode < CodiphiNode
  def emit(data)
    p "Permission #{integer.text_value}"
  end
end