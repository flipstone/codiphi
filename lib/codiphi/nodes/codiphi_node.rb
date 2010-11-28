class CodiphiNode < Treetop::Runtime::SyntaxNode
  def completion_transform(data)
    # puts "xform #{self}"
    unless (terminal?)
      elements.each{ |e| e.completion_transform(data) if e.respond_to? :completion_transform } 
    end
  end
  
  def gather_assertions(assertion_list)
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
    while test_upnode(upnode) do
      if upnode.declarative?
        return upnode
      else
        upnode = upnode.parent
      end
    end
    nil
  end
  
  def test_upnode(upnode)
    if (!upnode.nil? &&
        upnode != self &&
        upnode.class != CodexNode)
      return true
    end
    false
  end
end