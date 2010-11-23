module Codiphi
  class Engine

    attr_accessor :data
    attr_accessor :transformed_data
    attr :syntax_tree
    
    def initialize(data)
      @data = data
    end
    
    def emit
      run_transform
      JSON.generate(@transformed_data)
    end

    def cost
      running_cost = 0
      run_transform
      say "calculating cost" do
        traverse_data_for_key(@transformed_data, "cost") do |target_value|
          running_cost += target_value
        end
      end      
      running_cost
    end

    def run_transform
      render_tree
      list_data = @data.clone
      @syntax_tree.transform(list_data, Hash.new)
      @transformed_data = list_data
    end

    def render_tree
      raise "List file must include a root-level 'list' element." unless @data["list"]   

      say "inspecting list for schematic" do
        raise "List element must include a 'schematic' element." unless @data["list"]["schematic"]
      end
  
      schematic_path = @data["list"]["schematic"]
      schematic_data = Support.read_schematic(schematic_path)
      @syntax_tree = Parser.parse(schematic_data)
    end

    def traverse_data_for_key(data, key, &block)
      data.each do |k,v|
        if (k == key)
          # do the block
          block.call(v)
        else
          # check this node's children
          traverse_data_for_key(v, key, &block) if v.class == Hash
        end
      end
    end

  end
end