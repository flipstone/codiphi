module Codiphi
  module Functions
    define_function :count do |data, name|
      Transform.fold_selected(
        data,
        0,
        -> d { d[Tokens::Name] == name },
        -> data, count do
          count + (data.has_count? ? data.count_value : 1)
        end
      )
    end
  end
end
