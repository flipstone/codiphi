require 'spec_helper'

describe EngineController do
  integrate_views

  describe "create" do
    it "succeeds" do
      post :create, list: <<-end_list
---
list:
  description: First Man Standing
  schematic: test/hero1
  author: Codiphi Developer
  author_email: development@flipstone.com
  variant: legal
  version: "1"
  model:
  - type: hero
    description: Neo
    count: 1
end_list
      response.should be_success
    end

    it "renders html with result data" do
      Factory.create :schematic, name: "test/hero1"

      post :create, list: <<-end_list
---
list:
  description: First Man Standing
  schematic: test/hero1
  author: Codiphi Developer
  author_email: development@flipstone.com
  variant: legal
  version: "1"
  model:
  - type: hero
    description: Neo
    count: 1
end_list

      response.should have_selector('.emitted_data pre') do |tag|
        YAML.load(tag.inner_text).should == YAML.load(<<-end_list)
---
list:
  description: First Man Standing
  schematic: test/hero1
  author: Codiphi Developer
  author_email: development@flipstone.com
  variant: legal
  version: "1"
  model:
  - type: hero
    description: Neo
    count: 1
    cost: 100
  cost_measure: points
  cost: 100
end_list
      end
    end

    it "accepts posts as params hash" do
      Factory.create :schematic, name: "test/hero1"

      post :create, list: {
        description: "First Man Standing",
        schematic: "test/hero1",
        author: "Codiphi Developer",
        author_email: "development@flipstone.com",
        variant: "legal",
        version: "1",
        model: [{
          type: "hero",
          description: "Neo",
          count: 1
        }]
      }

      response.should have_selector('.emitted_data pre') do |tag|
        YAML.load(tag.inner_text).should == YAML.load(<<-end_list)
---
list:
  description: First Man Standing
  schematic: test/hero1
  author: Codiphi Developer
  author_email: development@flipstone.com
  variant: legal
  version: "1"
  model:
  - type: hero
    description: Neo
    count: 1
    cost: 100
  cost_measure: points
  cost: 100
end_list
      end
    end
  end

  describe "show" do
    it "renders" do
      get :show
      response.should be_success
    end
  end
end
