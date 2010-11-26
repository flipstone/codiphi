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

    # return sum of <count> for all <name> nodes with a child of type:<name>
    def self.count_for_expected_type_on_name(data, expected_type, expected_name)
      count = 0

      data.each do |k,v|
        # first, count on this child's values
        subcount = 0
        subcount = count_for_expected_type_on_name(v, expected_type, expected_name) if v.class == Hash

        # multiply by my count if any subcounts
        if (k == expected_type || subcount > 0)
          # this is our guy, if child "type" == :name 
          if ("list" == k || v.class == Hash || subcount > 0)
            if (subcount > 0 || v.include?("type") && v["type"] == expected_name)
              nodecount = 1

              # see if we have a user-provided count
              if (v.include?("count"))
                nodecount = v["count"]
              end

              nodecount = nodecount * subcount if subcount > 0
              count += nodecount
            end
          end
        end
      end

      count
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
