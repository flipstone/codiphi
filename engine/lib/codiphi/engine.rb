module Codiphi
  #
  # Engine coordinates transformations against schematics
  #
  class Engine
    include R18n::Helpers
    Version = [0,1,0]

    attr :data, :namespace, :options

    def has_errors?
      errors.any?
    end

    def initialize(data, options = {})
      @options = options
      @schematic = options[:schematic]
      @data = data
      R18n.set(R18n::I18n.new(options[:locale] || 'en', "#{BASE_PATH}/r18n"))
    end

    def emitted_data
      if has_errors?
        @data.merge Tokens::ListErrors => errors.map{ |f| f.to_s }
      else
        decanonicalized_result
      end
    end

    def errors
      namespace_errors | validation_errors
    end

    def validating?
      options[:validate] || !options.key?(:validate)
    end

    def validation_errors
      @validation_errors ||= if validating?
        Traverse.verify_named_types(completed_data, namespace) |
        assertion_errors
      else
        []
      end
    end

    def canonical_data
      @canonical_data ||= say_ok "expanding input to canonical structure" do
        Support.expand_to_canonical @data, namespace
      end
    end

    def decanonicalized_result
      @decanonicalized_result ||= say_ok "cleaning output of canonical artifacts" do
        Support.remove_canonical_keys completed_data
      end
    end

    def assertions
      @assertions ||= begin
        _, assertions = say_ok t.assertions.gathering do
          syntax_tree.gather_assertions completed_data, []
        end
        assertions
      end
    end

    def assertion_errors
      warn t.assertions.none if assertions.empty?
      @assertion_errors ||= assertions.map do |asst|
        target_node = asst.parent_declaration
        target_type = _type_helper_for_assertion(asst)

        say_ok t.assertions.checking(asst.text_value,target_type,target_node) do
          Transform.fold_type(completed_data, target_node, []) do |node, errors|
            count = Traverse.count_for_expected_type_on_name(
                                node,
                                asst.type_val,
                                asst.name_val)

            errors | _do_count_assertion(asst, count, "#{target_node}#{target_type}")
          end
        end
      end.flatten
    end

    def _do_count_assertion(assertion, count, parent_string)
      target = assertion.integer_val

      case assertion.op_val
      when Tokens::Expects
        if count < target
          [ExpectedNotMetException.new(assertion, parent_string)]
        end
      when Tokens::Permits
        if count > target
          [PermittedExceededException.new(assertion, parent_string)]
        end
      end || []
    end

    def _type_helper_for_assertion(a)
      a.parent_declaration == Tokens::List ?
        "" :
        " #{a.parent_declaration_node.type.text_value}"
    end

    def cost(data)
      running_cost = 0
      say_ok t.bin.calculating do
        running_cost = Traverse.for_cost(data)
      end
      running_cost
    end

    def completed_data
      @completed_data ||= begin
        data,_ = syntax_tree.completion_transform(canonical_data, namespace)
        list_node = data[Tokens::List]
        if list_node
          # the cost is set to zero before calculating cost because
          # otherwise it will be included in the cost again if a list is
          # double processed
          data = data.merge Tokens::List => list_node.set_cost(0)
          data = data.merge Tokens::List => list_node.set_cost(cost(data))
        end
        data
      end
    end

    def schematic
      @schematic ||= begin
        list_node = @data[Tokens::List]
        raise t.assertions.no_list unless list_node

        schematic_path = list_node[Tokens::Schematic]
        bin_msg = t.bin
        say_ok bin_msg.inspecting do
          raise bin_msg.no_schematic unless schematic_path
        end

        Support.read_schematic(schematic_path)
      end
    end

    def syntax_tree
      @syntax_tree ||= Parser.parse(schematic)
    end

    def gathered_declarations
      @gather_declarations ||= syntax_tree.gather_declarations(Namespace.new, [])
    end

    def namespace_errors
      gathered_declarations.last
    end

    def namespace
      gathered_declarations.first
    end
  end
end
