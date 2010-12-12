module Codiphi
  class NodeException < RuntimeError
    include R18n::Helpers
    
    attr :node
    
    def initialize(node)
      @node = node
    end
    
  end

  class AssertionException < NodeException
    def initialize(node, target_description)
      @node = node
      @target_description = target_description
    end
  end
  
  class NoSuchNameException < NodeException
    def to_s
      t.assignment.no_such_name(*@node.named_type_values)
    end
  end

  class ExpectedNotMetException < AssertionException
    def to_s
      t.assertions.fail.expected(
                @node.integer_val,
                @node.name_val,
                @node.type_val,
                @target_description)    
    end
  end

  class PermittedExceededException < AssertionException
    def to_s
      t.assertions.fail.permitted(
                @node.integer_val,
                @node.name_val,
                @node.type_val,
                @target_description)    
    end
  end

end