module Codiphi
  class CodiphiNode < Treetop::Runtime::SyntaxNode
    def recurse_to_children(method, args)
      unless terminal?
        elements.each{ |e| e.send(method, *args) if e.respond_to? method }
      end
    end

    def fold(method, *args)
      autowrap = (args.size == 1)

      result = if terminal?
        args
      else
        elements.inject(args) do |args,e|
          if e.respond_to? method
            new_args = e.send(method, *args)
            autowrap ? [new_args] : new_args
          else
            args
          end
        end
      end

      autowrap ? result.first : result
    end

    def gather_declarations(namespace, errors)
      fold(:gather_declarations, namespace, errors)
    end

    def completion_transform(data, namespace)
      fold(:completion_transform, data, namespace)
    end

    def gather_assertions(data, namespace, assertion_list, enclosing_condition)
      recurse_to_children(:gather_assertions, 
        [data, namespace, assertion_list, enclosing_condition])
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
end
