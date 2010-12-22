class EngineController < ApplicationController
  def create
    list = params[:list]
    schematic = Codiphi::SupportSchematic.find_by_name list[:schematic]
    
    engine = Codiphi::Engine.new(list, schematic.body)
    engine.completion_transform

    render json: engine.emitted_data
  end
end
