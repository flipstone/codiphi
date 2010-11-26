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
      passed = pass_assertions
      unless passed
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
      @assertions = []
      render_tree unless @syntax_tree
      run_completeness_transform unless @transformed_data
      say_ok "gathering assertions from schematic" do
        @syntax_tree.gather_assertions(@assertions)
      end
      true
    end

    def pass_assertions
      if (@assertions.nil? || @assertions.empty?)
        warn "no assertions in schematic"
        return true
      end
      failures = []
      @assertions.each do |asst|
        say_ok "checking assertion '#{asst.text_value}' on node <#{asst.parent_declaration}>" do
          # find node <#{asst.parent_declaration}> and run counts
          Traverse.matching_key(asst.parent_declaration)
          Traverse.count_for_expected_type_on_name(@transformed_data, asst.name.text_value) do |leaf|
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
      return true
    end

    def cost
      running_cost = 0
      say_ok "calculating cost" do
        Traverse.matching_key(@transformed_data, "cost") do |target_value|
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

      say_ok "inspecting list for schematic" do
        raise "List element must include a 'schematic' element." unless @data["list"]["schematic"]
      end
  
      schematic_path = @data["list"]["schematic"]
      schematic_data = Support.read_schematic(schematic_path)
      @syntax_tree = Parser.parse(schematic_data)
    end
  end
end