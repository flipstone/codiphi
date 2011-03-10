module Codiphi
  module Transform
    def self.recurseable?(v)
      Support.recurseable?(v)
    end

    CanonicalKeys = [Tokens::Type]

    def self.fold_selected(data, memo, selector, operation)
      children = case data
        when Hash then
          if selector[data]
            memo = operation[data, memo]
          end
          data.values
        when Array then data
        else []
      end

      children.inject(memo) { |memo,e| fold_selected(e, memo, selector, operation) }
    end

    def self.fold_type(data, key, memo, &block)
      fold_selected data,
                    memo,
                    -> d { d[Tokens::Type] == key },
                    block

    end

    def self.transform(data, node_op, child_op)
      case data
      when Hash
        data = node_op[data] || data
        data.each_with_object({}) do |(k,v),h|
          h[k] = child_op[k,v] || v
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

    def self.expand_to_canonical(data, namespace, schematic_type=nil)
      transform data,

                -> data do
                  unless schematic_type.nil?
                    data.merge Tokens::Type => schematic_type
                  end
                end,

                -> k,v do
                  if recurseable?(v)
                    expand_to_canonical(v, namespace, k)
                  elsif namespace.declared_type?(k)
                    { Tokens::Name => v, Tokens::Type => k }
                  end
                end
    end

    def self.remove_canonical_keys(data)
      transform data,

                -> data do
                  data.reject {|k,v| CanonicalKeys.include?(k) }
                end,

                -> k,v do
                  if recurseable?(v)
                    remove_canonical_keys(v)
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
                  end
                end
    end
  end
end
