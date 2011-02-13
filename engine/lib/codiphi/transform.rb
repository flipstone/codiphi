module Codiphi
  module Transform
    def self.recurseable?(v)
      Support.recurseable?(v)
    end

    def self.transform(data, node_op, child_op)
      case data
      when Hash
        data = node_op[data] || data
        data.each_with_object({}) do |(k,v),h|
          h[k] = child_op[k,v]
        end
      when Array
        data.map do |k|
          if recurseable?(k)
            transform k, node_op, child_op
          else
            k
          end
        end
      end
    end

    def self.matching_named_type(data, schematic_name, schematic_type, &block)
      transform data,

                -> data do
                  if schematic_type == Tokens::List && data.is_list_node? ||
                    (data.is_named_type?(schematic_name, schematic_type))
                    yield data
                  end
                end,

                -> k,v do
                  if recurseable?(v)
                    matching_named_type(v, schematic_name, schematic_type, &block)
                  else
                    v
                  end
                end
    end
  end
end
