module Codiphi
  module Traverse
    def self.recurseable?(v)
      Support.recurseable?(v)
    end

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
      mymult = 1

      case data
      when Hash
        data.each do |k,v|
          # first, get this child's costs
          if recurseable?(v)
            subcost += for_cost(v)
          end
        end

        if data.has_count?
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

      subcost * mymult
    end

    def self.verify_named_types(data, namespace)
      # puts "checking data #{data}"
      child_errors = case data
      when Hash then data.values
      when Array then data
      else []
      end.map { |e| verify_named_types(e, namespace) }.flatten

      self_errors = if Hash === data
        name, type = data.named_type_values

        if namespace.declared_type?(type) &&
          !namespace.named_type?(name,type)
          [NoSuchNameException.new(data)]
        end
      end || []

      self_errors | child_errors
    end
  end
end
