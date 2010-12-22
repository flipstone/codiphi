class EngineController < ApplicationController
  def create
    list = params[:list].to_hash

    schematic = Schematic.find_by_name list["schematic"]

    if schematic
      engine = Codiphi::Engine.new({"list" => list}, schematic.body)
      engine.completion_transform

      render json: engine.emitted_data
    else
      render json: {}
    end
  end
end
