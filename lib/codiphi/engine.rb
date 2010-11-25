module Codiphi
  class Engine
    Version = [0,1,0]
    
    attr_accessor :data
    attr_accessor :transformed_data
    attr_accessor :emitted_data
    attr :syntax_tree
    attr :assertions
    
    def initialize(data)
      @data = data
      @context = Hash.new
    end
    
    def emit
      @emitted_data = JSON.generate(@transformed_data)
    end
    
    def transform
      run_completeness_transform
      emit
    end
    
    def validate
      run_gather_assertions
      
      unless pass_assertions
        # return the original file with appended errors
        failclone = @data.clone
        failclone["list-errors"] = context["list-errors"]
        @transformed_data = failclone
      end
      emit
    end

    def apply_cost
      (@transformed_data["list"]["cost"] = cost) if @transformed_data["list"]
    end

    def run_gather_assertions
      render_tree unless @syntax_tree
      run_completeness_transform unless @transformed_data
      @syntax_tree.gather_assertions(@assertions)
      true
    end

    def pass_assertions
      unless (@assertions.nil? || @assertions.empty?)
        failures = []
        @assertions.each do |asst|
          say "checking assertion '#{asst.text_value}' on node <#{asst.parent_declaration}>" do
            # probably need a loop for each kind of assertion operator?
            traverse_data_for_key(@transformed_data, asst.name.text_value) do |leaf|
              if (true)
                # passed
              else
                failures << "ARGLE"
              end
            end
          end
        end
        unless failures.empty?        
          context["list-errors"] = failures 
          return false
        end
      end
      return true
    end

    def cost
      running_cost = 0
      say "calculating cost" do
        traverse_data_for_key(@transformed_data, "cost") do |target_value|
          running_cost += target_value
        end
      end      
      running_cost
    end

    def run_completeness_transform
      render_tree
      dataclone = @data.clone
      @syntax_tree.transform(dataclone, @context)
      @transformed_data = dataclone
      apply_cost
      true
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