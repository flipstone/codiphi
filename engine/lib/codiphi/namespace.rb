module Codiphi
  class Namespace < Hash
    def initialize(*args)
      super(*args)
      freeze
    end

    def declared_type?(type)
      includes_value_for_key?(:types_list, type)
    end

    def named_type?(name, type)
      includes_value_for_key?(name, type)
    end

    def add_named_type(name, type)
      set_arrayed_value(name, type).set_arrayed_value(:types_list, type)
    end

    def merge(*args)
      super(*args).tap { |n| n.freeze }
    end

    protected

    def set_arrayed_value(key, value)
      merge key => ((self[key] || []) + [value])
    end

    def includes_value_for_key?(key, value)
      (!self[key].nil? && self[key].include?(value))
    end
  end
end
