require_relative './codiphi_node.rb'

class PermissionNode < CodiphiNode
  def emit(data)
    puts "Permission #{integer.type_value}"
  end
end