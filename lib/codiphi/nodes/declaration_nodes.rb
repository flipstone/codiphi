require_relative './codiphi_node'

class DeclarationNode < CodiphiNode
  def emit(data)
    p "#{type.text_value} #{declared.text_value}"
  end
end

class DeclarationListNode < CodiphiNode
  def emit(data)
    children = elements.map { |e| 
      "#{e.to_s} : #{e.text_value}"
    }
    puts "\n\nLIST: #{self.text_value}"
    puts "declaration_list children: #{children}"
    puts "declaration_list's declaration #{declaration}" if declaration
    puts "declaration_list's recursive declaration_list: #{declaration_list}" if declaration_list
    declaration.emit(data)
    declaration_list.emit(data) if declaration_list
  end
end

class DeclarationBlockNode < CodiphiNode
  def emit(data)
    puts "declaration_block list count: #{declaration_list.elements.count}"
    declaration_list.emit(data)
  end
end
