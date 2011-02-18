require_relative './spec_helper.rb'

module Codiphi

  describe ConditionNode do 
    describe "gathering expected assertions" do

      it "ignores declaration children" do 
        parentnode = declaration_mock("model", "sergeant")
        declaration_node = declaration_mock("model", "gray_warden")
        node = condition_mock('?',"weapon", "supergun", declaration_node, parentnode)

        namespace = Namespace.new.add_named_type("supergun", "weapon")

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

        _, list = node.gather_assertions(indata, [])
        list.should be_empty
      end

      xit "errors on bad name reference" do end

      xit "performs completion on assignments" do
        parentnode = declaration_mock("model", "sergeant")
        assignment_node = assignment_mock('+',"weapon", "death_bombs")
        node = condition_mock('?',"weapon", "supergun", assignment_node, parentnode)

        namespace = Namespace.new
                    .add_named_type("death_bombs", "weapon")
                    .add_named_type("supergun", "weapon")

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

        _, list = node.gather_assertions(indata, [])
        indata["unit"]["model"][0]["weapon"].should be_is_named_type("death_bombs", "weapon")
      end
      xit "collects cost assignments" do end

      it "doesn't add children on negative condition" do 
        parentnode = declaration_mock("sergeant", "model")
        assertion_node = assertion_mock('permits', 0, "ammunition", "bullets")
        node = condition_mock('?',"weapon", "supergun", assertion_node, parentnode)

        namespace = Namespace.new.add_named_type("supergun", "weapon")

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

        _, list = node.gather_assertions(indata, [])
        list.should be_empty
      end

      it "collects single assertions" do
        parentnode = declaration_mock("model", "sergeant")
        assertion_node = assertion_mock('permits', 0, "ammunition", "bullets")
        node = condition_mock('?',"weapon", "supergun", assertion_node, parentnode)

        namespace = Namespace.new.add_named_type("supergun", "weapon")

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

        _, list = node.gather_assertions(indata, [])
        list.should_not be_empty
        list.should be_include assertion_node
      end
    end
  end

end
