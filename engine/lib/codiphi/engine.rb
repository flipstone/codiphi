module Codiphi
  #
  # Engine coordinates transformations against schematics
  #
  class Engine
    include R18n::Helpers
    Version = [0,1,0]

    attr_accessor :namespace, :data, :original_data, :emitted_data
    attr :syntax_tree, :assertions

    def has_errors?
      @namespace.has_errors?
    end

    def initialize(data, schematic=nil,locale='en')
      @schematic = schematic
      @data = Marshal.load( Marshal.dump(data))
      # poor man's clone
      @original_data = Marshal.load( Marshal.dump(@data))
      @namespace = Namespace.new
      R18n.set(R18n::I18n.new(locale, "#{BASE_PATH}/r18n"))
    end

    def emit
      cleanup_data
      data_to_emit = @data
      data_to_emit = @original_data if has_errors?
      @emitted_data = data_to_emit
    end

    def returning_new
      dup.tap do |new_e|
        new_e.instance_variables.each do |i|
          v = new_e.instance_variable_get i
          new_e.instance_variable_set(i, Marshal.load(Marshal.dump(v)))
        end
        yield new_e
      end
    end

    def completion_transform
      returning_new do |e|
        e.run_completeness_transform
        e.emit
      end
    end

    def expand_data
      say_ok "expanding input to canonical structure" do
        @data = Support.expand_to_canonical(@data, @namespace)
      end
    end

    def cleanup_data
      say_ok "cleaning output of canonical artifacts" do
        @data = Support.remove_canonical_keys(@data)
      end
    end

    def validate
      returning_new do |e|
        e.run_validate
        e.emit
      end
    end

    def run_validate
      @namespace.clear_errors
      render_tree unless @syntax_tree
      @syntax_tree.gather_declarations(@namespace) unless @namespace
      expand_data
      Traverse.verify_named_types(@data, @namespace)
      run_gather_assertions
      check_assertions
      if has_errors?
        # decorate the original file with appended errors
        original_data[Tokens::ListErrors] = @namespace.errors.map{ |f| f.to_s }
      end
    end

    def apply_cost
      list_node = @data[Tokens::List]
      list_node.set_cost(0) if list_node
      list_node.set_cost(cost) if list_node
    end

    def run_gather_assertions
      @assertions = []
      say_ok t.assertions.gathering do
        @syntax_tree.gather_assertions(@data, @namespace, @assertions, true)
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
      return true if no_assertions?
      @assertions.each do |asst|
        target_node = asst.parent_declaration
        target_type = _type_helper_for_assertion(asst)

        say_ok t.assertions.checking(asst.text_value,target_type,target_node) do

          Traverse.matching_key(@data, target_node) do |node|
            count = Traverse.count_for_expected_type_on_name(
                                node,
                                asst.type_val,
                                asst.name_val)

            parent_string = _namedtype_helper_for_assertion(target_node, target_type)
            _do_count_assertion(asst, count, parent_string)
          end
        end
      end
    end

    def _do_count_assertion(assertion, count, parent_string)
      target = assertion.integer_val

      error = case assertion.op_val
        when Tokens::Expects then
          ExpectedNotMetException.new(assertion,parent_string) unless count >= target
        when Tokens::Permits then
          PermittedExceededException.new(assertion, parent_string) unless count <= target
      end
      @namespace.add_error(error) if error
    end

    def _type_helper_for_assertion(a)
      a.parent_declaration == Tokens::List ?
        "" :
        " #{a.parent_declaration_node.type.text_value}"
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
      @syntax_tree.gather_declarations(@namespace)
      expand_data
      @data,_ = @syntax_tree.completion_transform(@data, @namespace)
      apply_cost
      true
    end

    def load_schematic_from_data
      list_node = @data[Tokens::List]
      raise t.assertions.no_list unless list_node

      schematic_path = list_node[Tokens::Schematic]
      bin_msg = t.bin
      say_ok bin_msg.inspecting do
        raise bin_msg.no_schematic unless schematic_path
      end

      @schematic = Support.read_schematic(schematic_path)
    end

    def render_tree
      load_schematic_from_data unless @schematic
      @syntax_tree = Parser.parse(@schematic)
    end
  end
end
