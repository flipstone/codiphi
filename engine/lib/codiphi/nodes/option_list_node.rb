module Codiphi
  class OptionListNode < CodiphiNode
    def name_values
      [name.text_value] + rest_names.elements.map do |r|
        r.name.text_value
      end
    end
  end
end
