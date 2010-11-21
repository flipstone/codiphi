module Codiphi
  class Parser
    Treetop.load File.join(BASE_PATH, "lib/codiphi/codiphi.treetop")
    @@parser = CodiphiParser.new
    
    def self.parse(schematic)
      tree = @@parser.parse(schematic)
            
      if(tree.nil?)
        raise ParseException, "Unable to parse Codiphi schematic:\n#{@@parser.failure_reason}"
      end
      
      return tree
    end

    # sc: A useful method if inspecting the tree directly, but unsafe for emit
    # removing the SyntaxNodes compromises the generated labels
    # (they point to the wrong child elements)
    def self.clean_tree(tree)
       return if(tree.elements.nil?)
       tree.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
       tree.elements.each {|node| self.clean_tree(node) }
     end

     # sc: extend this to provide richer failure messages
     def self.failure_reason
       @@parser.failure_reason
     end
  end
  
  class ParseException < Exception
  end
  
end