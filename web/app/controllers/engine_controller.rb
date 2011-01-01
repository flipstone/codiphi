class EngineController < ApplicationController
  def show

  end

  def create
    list = YAML.load params[:list]

    schematic = Schematic.find_by_name list["list"]["schematic"]

    if schematic
      @engine = Codiphi::Engine.new(list, schematic.body)
      @engine.completion_transform
    end

    render action: :show
  end
end
