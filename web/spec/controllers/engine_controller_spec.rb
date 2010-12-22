require 'spec_helper'

describe EngineController do
  describe "create" do
    it "succeeds" do
      post :create, list: {}
      response.should be_success
    end

    it "renders json with result data" do
      Factory.create :schematic, name: "hero1"

      post :create, list: {
        description: "First Man Standing",
        schematic: "hero1",
        author: "Codiphi Developer",
        author_email: "development@flipstone.com",
        variant: "legal",
        version: "1",
        model: [{
          type: "hero",
          description: "Neo",
          count: "1"
        }]
      }

      ActiveSupport::JSON.decode(response.body).should == {
        "list" => {
          "description" => "First Man Standing",
          "schematic" => "hero1",
          "author" => "Codiphi Developer",
          "author_email" => "development@flipstone.com",
          "variant" => "legal",
          "version" => "1",
          "model" => [{
            "type" => "hero",
            "description" => "Neo",
            "count" => 1,
            "cost" => 100,
          }],
          "cost_measure" => "points",
          "cost" => 100
        }
      }
    end
  end
end
