module EngineHelper
  TypeToken = "type"
  
  def haml_from_list(list)
    list.each do |k,v|
      if v.class == Array
        haml_tag :div, :class => "#{k}" do
          haml_tag :div, :class => "sequence-frame" do
            haml_tag :div, :class => "sequence-label" do
              haml_concat(k.pluralize.titleize)
            end
            haml_tag :div, :class => "sequence" do
              v.each do |child_v|
                haml_from_list(child_v)
              end
            end
          end
        end
      else
        case k
        when TypeToken
          haml_tag :div, :class => "node-type" do
            haml_tag :div, :class => "sequence-node" do
              countstr = list[Codiphi::Tokens::Count] ?
                         "#{list[Codiphi::Tokens::Count]}x " :
                         ""
              haml_concat("#{countstr}#{v.titleize}")
              haml_tag :div, :class => "cost" do
                haml_concat(list[Codiphi::Tokens::Cost])
              end
            end
          end
        when Codiphi::Tokens::Count, 
             Codiphi::Tokens::Cost,
             Codiphi::Tokens::CostMeasure,
             Codiphi::Tokens::Schematic
          # do nothing
        when "description", "name"
          haml_tag :div, :class => k do
           haml_concat(list[k])
          end
        else
          haml_tag :div, :class => "custom_node #{k}" do
            haml_concat("#{k}: #{v.humanize}")
          end
        end
      end
    end
  end
end
