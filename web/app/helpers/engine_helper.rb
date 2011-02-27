module EngineHelper
  TypeToken = "type"
  
  def haml_from_list(list)
    list.each do |k,v|
      if v.class == Array
          haml_tag :div, :class => "sequence-label" do
            haml_concat(k.pluralize.titleize)
          end
          haml_tag :div, :class => "sequence #{k}" do
            v.each do |child_v|
              haml_from_list(child_v)
            end
          end
      else
        case k
        when TypeToken
          haml_tag :div, :class => "node_type" do
            haml_tag :div, :class => "node #{k}" do
              countstr = list[Codiphi::Tokens::Count] ?
                         "#{list[Codiphi::Tokens::Count]}x " :
                         ""
              haml_concat("#{countstr}#{v.titleize}")
            end
            if list[Codiphi::Tokens::Cost]
              haml_tag :div, :class => "cost" do
                haml_concat(list[Codiphi::Tokens::Cost])
              end
            end
          end
        when Codiphi::Tokens::Cost,
             Codiphi::Tokens::Count, 
             Codiphi::Tokens::CostMeasure,
             Codiphi::Tokens::Schematic
             
          # don't display
        else
          haml_tag :div, :class => "node #{k}" do
            haml_concat(v.humanize)
          end
        end
      end
    end
  end
end
