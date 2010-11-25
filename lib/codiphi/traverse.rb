module Codiphi
  module Traverse
    def self.for_match(data, schematic_type, schematic_name, &block)
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
          for_match(v, schematic_type, schematic_name, &block) if v.class == Hash
        end
      end
    end
    
  end
end
