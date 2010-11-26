module Codiphi
  module Traverse

    # matches all <name> nodes with a child of type:<name>
    def self.matching_named_type(data, schematic_type, schematic_name, &block)
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
          matching_named_type(v, schematic_type, schematic_name, &block) if v.class == Hash
        end
      end
    end

    # matches all <key> nodes 
    def self.matching_key(data, key, &block)
      data.each do |k,v|
        if (k == key)
          # do the block
          block.call(v)
        else
          # check this node's children
          matching_key(v, key, &block) if v.class == Hash
        end
      end
    end
    
  end
end
