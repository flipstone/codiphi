module Codiphi
  Treetop.load File.join(BASE_PATH, "lib/codiphi/tokens.treetop")
  Treetop.load File.join(BASE_PATH, "lib/codiphi/formula.treetop")
  Treetop.load File.join(BASE_PATH, "lib/codiphi/codiphi.treetop")
  class Parser
    @@parser = CodiphiParser.new

    def self.parse(schematic, options = {})
      tree = @@parser.parse(schematic, options)

      if tree.nil?
        raise ParseException, "Unable to parse Codiphi schematic:\n#{@@parser.failure_reason}"
      end

      tree
    end

    # sc: A useful method if inspecting the tree directly, but unsafe for named references
    # (removing the SyntaxNodes compromises the Treetop-generated references to child nodes)
    # Instead, check child elements respond_to? the intended recursion call(s) before chaining
    def self.clean_tree(tree)
       return if(tree.elements.nil?)
       tree.elements.delete_if { |node| ["Treetop::Runtime::SyntaxNode"].include? node.class.name  }
       tree.elements.each {|node| self.clean_tree(node) }
       tree
     end

     # sc: extend this to provide richer failure messages
     def self.failure_reason
       @@parser.failure_reason
     end
  end

  class ParseException < Exception
  end

  module Formula
    class Parser
      @@parser = Codiphi::FormulaParser.new

      def self.parse(schematic, options = {})
        tree = @@parser.parse(schematic, options)

        if tree.nil?
          raise ParseException, "Unable to parse Codiphi formula :\n#{@@parser.failure_reason}"
        end

        tree
      end

      def self.failure_reason
        @@parser.failure_reason
      end
    end
  end
end
