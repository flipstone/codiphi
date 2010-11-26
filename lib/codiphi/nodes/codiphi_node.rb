class CodiphiNode < Treetop::Runtime::SyntaxNode
  def transform(data)
    elements.each{ |e| e.transform(data) if e.respond_to? :transform } unless terminal?
  end
  
  def gather_assertions(assertion_list)
    # say "gathering #{self}"
    elements.each{ |e| e.gather_assertions(assertion_list) if e.respond_to? :gather_assertions } unless terminal?
  end
  
  def declarative?
    false
  end

  def parent_declaration
    parent_declaration_node.declared.text_value
  end

  def parent_declaration_node
    upnode = parent
    while !upnode.nil? do
      if upnode.declarative?
        return upnode
      else
        upnode = upnode.parent
      end
    end
    nil
  end  
end