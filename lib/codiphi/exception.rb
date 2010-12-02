module Codiphi
  
  class NodeException < RuntimeError
    attr :node
    
    def initialize(node)
      @node = node
    end
  end
  
  class NoSuchNameException < NodeException
  end
    
end