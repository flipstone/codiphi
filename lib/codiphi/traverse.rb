module Codiphi
  module Traverse

    # matches all type=<schematic_name> Hash nodes with an immediate (2 levels up) 
    # parent of <schematic_type>
    def self.matching_named_type(data, schematic_type, schematic_name, matched_parent=0, &block)
      matched_parent = 0 if (matched_parent > 2)
      case data
      when Hash
        # special case for list
        if ("list" == schematic_type && data.keys.include?("list"))
          block.call(data["list"])
        end

        # test this hash for type to match
        if (data.keys.include?("type") && data["type"] == schematic_name)
          block.call(data) if (matched_parent > 1)
        end
        # recurse on the attributes, looking for <schematic_type>
        data.each do |k,v|
          if (k == schematic_type)
            matched_parent += 1
          end
          if ([Hash, Array].include? v.class)
            matching_named_type(v, schematic_type, schematic_name, matched_parent, &block) 
          end
        end
        
      when Array
        matched_parent += 1 if (matched_parent > 0)
        data.each do |k|
          if ([Hash, Array].include? k.class)
            matching_named_type(k, schematic_type, schematic_name, matched_parent, &block) 
          end
        end # each
      end # case 
    end # def

    # return sum of <count> for all <name> nodes with a child of type:<name>
    def self.count_for_expected_type_on_name(data, expected_type, expected_name, matched_parent=false)
      subcount= 0
      count = 0
      mymult = 1
      case data
      when Hash
        data.each do |k,v|
          # first, get this child's counts
          previous_match = matched_parent || k==expected_type
          if [Hash, Array].include? v.class
            subcount += count_for_expected_type_on_name(v, expected_type, expected_name, previous_match)
          end
        end
        
        # see if I have a user-provided count
        if (data.keys.include?("count"))
          mymult = data["count"]
        end

        # test this hash for type to increments
        if (data.keys.include?("type") && data["type"] == expected_name)
          subcount += 1 if matched_parent
        end

      when Array
        data.each do |v|
          childcount = count_for_expected_type_on_name(v, expected_type, expected_name, matched_parent) 
          subcount += childcount if (matched_parent || subcount)
        end
      end
      
      count = (subcount * mymult)
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
