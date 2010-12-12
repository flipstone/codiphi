module Codiphi
  class Namespace < Hash
    
    def add_to_runlist(node_as_string)
      _set_arrayed_value(:runlist, node_as_string)
    end
    
    def has_run?(node_as_string)
      _includes_value_for_key?(:runlist, node_as_string)
    end
    
    def has_errors?
      !self[:errors].nil? && !self[:errors].empty?
    end
    
    def add_error(error)
      _set_arrayed_value(:errors, error)
    end
    
    def errors
      self[:errors]
    end
    
    def named_type?(name, type)
      _includes_value_for_key?(name, type)
    end
    
    def add_named_type(name, type)
      _set_arrayed_value(name, type)
    end
    
    def _set_arrayed_value(key, value)
      if self[key].nil?
        self[key] = [value]
      else
        self[key] << value
      end
      self[key]
    end

    def _includes_value_for_key?(key, value)
      (!self[key].nil? && self[key].include?(value))
    end
    
  end
end