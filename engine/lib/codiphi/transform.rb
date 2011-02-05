module Codiphi
  module Transform
    def self.recurseable?(v)
      Support.recurseable?(v)
    end

    def self.matching_named_type(data, schematic_name, schematic_type, &block)
      case data
      when Hash
        new_data = if schematic_type == Tokens::List && data.is_list_node? ||
                      (data.is_named_type?(schematic_name, schematic_type))
                     yield(data)
                   else
                     data
                   end

        # recurse on the attributes, looking for <schematic_type>
        new_data.each_with_object({}) do |(k,v),h|
          h[k] = if recurseable?(v)
                   matching_named_type(v, schematic_name, schematic_type, &block)
                 else
                   v
                 end
        end

      when Array
        data.map do |k|
          if recurseable?(k)
            matching_named_type(k, schematic_name, schematic_type, &block)
          else
            k
          end
        end
      end
    end
  end
end
