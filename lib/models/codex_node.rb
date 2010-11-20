require_relative './codiphi_node'

class CodexNode < CodiphiNode
  def validate(list)
    desc = list['description'] ? list['description'] : "Untitled List" 

    say %{validating json list "#{desc}"} do
      list["model"].should_not == nil
    end  
    
  end
  
  def cost(list)
    measure = "points"

    say "looking up cost measure" do
      measure = list["cost_measure"] if list["cost_measure"]
    end  

    return "0 #{measure}"
  end
    

end