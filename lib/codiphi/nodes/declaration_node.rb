require_relative './codiphi_node'

class DeclarationNode < CodiphiNode

  def emit(data)
    p type.text_value
  end

end