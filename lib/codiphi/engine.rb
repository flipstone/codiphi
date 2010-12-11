module Codiphi
  class Engine
    include R18n::Helpers
    Version = [0,1,0]
    
    attr_accessor :namespace, :data, :original_data, :emitted_data    
    attr :syntax_tree, :assertions, :failures
    
    def has_errors?
      !@failures.empty?
    end
    
    def initialize(data, locale='en')
      @data = data
      # poor man's clone
      @original_data = Marshal.load( Marshal.dump(@data))
      @context = Hash.new
      @namespace = Namespace.new
      @failures = []
      R18n.set(R18n::I18n.new(locale, "#{BASE_PATH}/r18n"))
    end
    
    def emit
      cleanup_data
      data_to_emit = @data
      data_to_emit = @original_data if has_errors?
      @emitted_data = data_to_emit
    end
    
    def completion_transform
      # scrub list-errors if present
      run_completeness_transform
      emit
    end
    
    def expand_data
      say_ok "expanding input to canonical structure" do
        Support.expand_to_canonical(@data, @namespace)
      end
    end

    def cleanup_data
      say_ok "cleaning output of canonical artifacts" do
        Support.remove_canonical_keys(@data)
      end
    end
    
    def validate
      expand_data
      run_gather_assertions
      check_assertions
      if has_errors?
        # decorate the original file with appended errors
        original_data["list-errors"] = @failures.map{ |f| f.to_s }
      end
      emit
    end

    def apply_cost
      (@data["list"]["cost"] = cost) if @data["list"]
    end

    def run_gather_assertions
      @assertions = []
      render_tree unless @syntax_tree
      say_ok t.assertions.gathering do
        @syntax_tree.gather_assertions(@assertions)
      end
      true
    end

    def no_assertions?
      if (@assertions.nil? || @assertions.empty?)
        warn t.assertions.none
        return true
      end
      false
    end

    def check_assertions
      @failures = []
      return true if no_assertions?
      @assertions.each do |asst|
        target_node = asst.parent_declaration
        target_type = _type_helper_for_assertion(asst)
        
        say_ok t.assertions.checking(asst.text_value,target_type,target_node) do
 
          Traverse.matching_key(@data, target_node) do |node|
            # get counts for matched node
            type = asst.type.text_value
            name = asst.name.text_value

            count = Traverse.count_for_expected_type_on_name(node, type, name)
            parent_string = _namedtype_helper_for_assertion(target_node, target_type)
            _do_count_assertion(asst, count, name, type, parent_string)
          end
        end
      end
    end

    def _do_count_assertion(a, count, name, type, parent_string)
      target = a.integer.text_value
      case a.assertion_operator.text_value
        when Tokens::Expects then
          @failures << t.assertions.fail.expected(target,name,type,parent_string) unless count >= target
        when Tokens::Permits then
          @failures << t.assertions.fail.permitted(target,name,type,parent_string) unless count <= target
        else
          warn t.assertions.unknown_operator
      end
    end
    
    def _type_helper_for_assertion(a)
      a.parent_declaration == Tokens::List ? "" : " #{a.parent_declaration_node.type.text_value}"
    end

    def _namedtype_helper_for_assertion(node, type)
      type == "" ? type : " #{type}"
      "#{node}#{type}"
    end

    def cost
      running_cost = 0
      say_ok t.bin.calculating do
        running_cost = Traverse.for_cost(@data)
      end      
      running_cost
    end

    def run_completeness_transform
      render_tree
      expand_data
      @syntax_tree.completion_transform(@data, @namespace)
      apply_cost
      true
    end

    def render_tree
      raise t.assertions.no_list unless @data["list"]   

      say_ok t.bin.inspecting do
        raise t.bin.no_schematic unless @data["list"]["schematic"]
      end
  
      schematic_path = @data["list"]["schematic"]
      schematic_data = Support.read_schematic(schematic_path)
      @syntax_tree = Parser.parse(schematic_data)
      @syntax_tree.gather_declarations(@namespace)
    end
  end
end