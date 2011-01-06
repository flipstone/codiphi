require_relative './spec_helper.rb'

module Codiphi

  describe ConditionNode do 
    describe "gathering expected assertions" do

      xit "collects multiple assertions" do end
      xit "errors on bad name reference" do end
      xit "collects and applies cost assignments" do end
      
      it "doesn't add children on negative condition" do 
        parentnode = declaration_mock("sergeant", "model")
        assertion_node = assertion_mock('permits', 0, "ammunition", "bullets")
        node = condition_mock('?',"weapon", "supergun", assertion_node, parentnode)

        namespace = Namespace.new
        namespace.add_named_type("supergun", "weapon")

        indata = {
          "unit" => {
            Tokens::Name => "scount_squad",
            Tokens::Type => "unit",
            "model" => [{
              Tokens::Name => "sergeant",
              Tokens::Type => "model",
              "weapon" => {
                Tokens::Name => "needlenet",
                Tokens::Type => "weapon"
              }
            }]
          }
        }

        list = []
        node.gather_assertions(indata, namespace, list, true)
        list.should be_empty
      end
        
      it "collects single assertions" do
        parentnode = declaration_mock("model", "sergeant")
        assertion_node = assertion_mock('permits', 0, "ammunition", "bullets")
        node = condition_mock('?',"weapon", "supergun", assertion_node, parentnode)

        namespace = Namespace.new
        namespace.add_named_type("supergun", "weapon")

        indata = {
          "unit" => {
            Tokens::Name => "scount_squad",
            Tokens::Type => "unit",
            "model" => [{
              Tokens::Name => "sergeant",
              Tokens::Type => "model",
              "weapon" => {
                Tokens::Name => "supergun",
                Tokens::Type => "weapon"
              }
            }]
          }
        }

        list = []
        node.gather_assertions(indata, namespace, list, true)
        list.should_not be_empty
        list.should be_include assertion_node
      end
    end
  end

end
