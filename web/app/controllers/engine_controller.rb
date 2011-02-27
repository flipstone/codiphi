class EngineController < ApplicationController
  def show

  end

  def haml
    data = Codiphi::Support.read_yaml "app/views/engine/haml-test.yml"
    @list = data["list"]
  end
  
  def create
    list_param = params[:list]

    if list_param.is_a?(String)
      data = YAML.load list_param
    else
      data = {"list" => list_param}
    end

    schematic = Schematic.find_by_name data["list"]["schematic"]

    if schematic
      @engine = Codiphi::Engine.new(data, schematic: schematic.body)
    end

    render action: :show
  end
end
