module Codiphi
  class Engine
    Version = [0,1,0]
    
    attr_accessor :data
    attr_accessor :original_data
    attr_accessor :emitted_data    
    attr :syntax_tree, :assertions, :failures
    
    def has_errors?
      !@failures.empty?
    end
    
    def initialize(data)
      @data = data
      # poor man's clone
      @original_data = Marshal.load( Marshal.dump(@data))
      @context = Hash.new
      @failures = []
    end
    
    def emit
      data_to_emit = @data
      data_to_emit = @original_data if has_errors?
      @emitted_data = data_to_emit
    end
    
    def transform
      # scrub list-errors if present
      run_completeness_transform
      emit
    end
    
    def validate
      run_gather_assertions
      check_assertions
      if has_errors?
        # decorate the original file with appended errors
        original_data["list-errors"] = @failures
      end
      emit
    end

    def apply_cost
      (@data["list"]["cost"] = cost) if @data["list"]
    end

    def run_gather_assertions
      @assertions = []
      render_tree unless @syntax_tree
      say_ok "gathering assertions from schematic" do
        @syntax_tree.gather_assertions(@assertions)
      end
      true
    end

    def check_assertions
      if (@assertions.nil? || @assertions.empty?)
        warn "no assertions in schematic"
        return true
      end
      @failures = []
      @assertions.each do |asst|
        target_node = asst.parent_declaration
        target_type = target_node == "list" ? "" : " #{asst.parent_declaration_node.type.text_value}"
        say_ok "checking assertion '#{asst.text_value}' on <#{target_type} #{target_node}>" do

          case asst.assertion_operator.text_value
          when "expects"
            # find node <target_node> and run counts
            Traverse.matching_key(@data, target_node) do |node|
              # get counts for matched node
              target = asst.integer.text_value
              type = asst.type.text_value
              type_s =  target > 1 ? "#{type}s" : type 
              name = asst.name.text_value
            
              count = Traverse.count_for_expected_type_on_name(node, type, name)
              @failures << "At least #{target} #{name} #{type_s} expected on #{target_node}#{target_type}" unless count >= target
            end
            break
          when "permits"
            # find node <target_node> and run counts
            Traverse.matching_key(@data, target_node) do |node|
              # get counts for matched node
              target = asst.integer.text_value
              type = asst.type.text_value 
              type_s =  target > 1 ? "#{type}s" : type 
              name = asst.name.text_value
            
              count = Traverse.count_for_expected_type_on_name(node, type, name)
              @failures << "At most #{target} #{name} #{type_s} expected on #{target_node}#{target_type}" unless count <= target
            end
            break
          default
            warn "unknown schematic assertion"
          end
        end
      end
    end

    def cost
      running_cost = 0
      say_ok "calculating cost" do
        Traverse.matching_key(@data, "cost") do |target_value|
          running_cost += target_value
        end
      end      
      running_cost
    end

    def run_completeness_transform
      render_tree
      @syntax_tree.transform(@data)
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