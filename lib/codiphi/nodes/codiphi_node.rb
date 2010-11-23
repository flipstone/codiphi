require 'rspec'

class CodiphiNode < Treetop::Runtime::SyntaxNode
  def transform(data, context)
    # puts "transform! #{self.class}"
    elements.each{ |e| e.transform(data, context) if e.respond_to? :transform } unless elements.nil?
  end
  
  def declarative?
    false
  end

  def traverse_data_for_match(data, schematic_type, schematic_name, &block)
    data.each do |k,v| 
      if (k == schematic_type)
        # this is our guy, verify child "type" = name
        if ("list" == k || 
             (
                v.class == Hash && 
                v.include?("type") && 
                v["type"] == schematic_name
              )
            )
          # do the block
          block.call(v)
        end
      else
        # check this node's children
        traverse_data_for_match(v, schematic_type, schematic_name, &block) if v.class == Hash
      end
    end
  end
  
end