module Codiphi
  module Traverse
    def self.recurseable?(v)
      Support.recurseable?(v)
    end

    def self.matching_named_type(data, schematic_name, schematic_type, &block)
      case data
      when Hash
        # special case for list
        if schematic_type == Tokens::List && data.is_list_node?
          block.call(data)
        end

        # test this hash for type to match
        if (data.is_named_type?(schematic_name, schematic_type))
          block.call(data)
        end

        # recurse on the attributes, looking for <schematic_type>
        data.each do |k,v|
          if recurseable?(v)
            matching_named_type(v, schematic_name, schematic_type, &block)
          end
        end

      when Array
        data.each do |k|
          if recurseable?(k)
            matching_named_type(k, schematic_name, schematic_type, &block)
          end
        end # each
      end # case 
    end # def

    # return sum of <count> for all <name> nodes with a child of type:<name>
    def self.count_for_expected_type_on_name(data, expected_type, expected_name)
      subcount = 0
      count = 0
      mymult = 1
      case data
      when Hash
        data.each do |k,v|
          # first, get this child's counts
          if recurseable?(v)
            subcount += count_for_expected_type_on_name(v, expected_type, expected_name)
          end
        end

        if (data.has_count?)
          mymult = data[Tokens::Count]
        end

        if (data.is_named_type?(expected_name, expected_type))
          subcount += 1
        end

      when Array
        data.each do |v|
          childcount = count_for_expected_type_on_name(v, expected_type, expected_name) 
          subcount += childcount if (v.is_named_type?(expected_name, expected_type) || subcount)
        end
      end

      count = (subcount * mymult)
      count
    end

    def self.for_cost(data)
      subcost= 0
      cost = 0
      mymult = 1

      case data
      when Hash
        data.each do |k,v|
          # first, get this child's costs
          if recurseable?(v)
            subcost += for_cost(v)
          end
        end
        if (data.has_count?)
          mymult = data.count_value
        end

        if data.has_cost?
          subcost += data.cost_value
        end

      when Array
        data.each do |v|
          childcost = for_cost(v) 
          subcost += childcost
        end
      end
      
      cost = (subcost * mymult)
      cost
    end

    # matches all <key> nodes
    def self.matching_key(data, key, &block)
      children = case data
        when Hash then
          data.values
          if (data[Tokens::Type] == key)
            block.call(data)
          end
          data.values
        when Array then data
        else []
      end

      children.each { |e| matching_key(e, key, &block) }

    end

    def self.verify_named_types(data, namespace)
      # puts "checking data #{data}"
      children = case data
        when Hash then
          name, type = data.named_type_values
          # puts "Checking type #{type} #{namespace.declared_type?(type)}"
          # puts "Checking name #{name} #{namespace.named_type?(name,type)}"
          if namespace.declared_type?(type) && !namespace.named_type?(name,type)
            namespace.add_error(NoSuchNameException.new(data))
          end
          data.values
        when Array then data
        else []
      end

      children.each { |e| verify_named_types(e, namespace) }
    end


  end
end
