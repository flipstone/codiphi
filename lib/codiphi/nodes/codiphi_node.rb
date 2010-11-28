class CodiphiNode < Treetop::Runtime::SyntaxNode

  def recurse_to_children(method, args)
    unless terminal?
      elements.each{ |e| e.send(method, *args) if e.respond_to? method }
    end
  end

  def gather_declarations(namespace)
    recurse_to_children(:gather_declarations, [namespace])
  end

  def completion_transform(data, namespace)
    recurse_to_children(:completion_transform, [data, namespace])
  end
  
  def gather_assertions(assertion_list)
    recurse_to_children(:gather_assertions, [assertion_list])
  end
  
  def declarative?
    false
  end

  def parent_declaration
    parent_declaration_node.name.text_value
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