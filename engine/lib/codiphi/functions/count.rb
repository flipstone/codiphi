module Codiphi
  module Functions
    define_function :count do |data, type|
      Transform.fold_type(data, type, 0) do |data, count|
        count + (data.has_count? ? data.count_value : 1)
      end
    end
  end
end
