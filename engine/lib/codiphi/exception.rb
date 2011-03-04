module Codiphi
  class NodeException < RuntimeError
    include R18n::Helpers

    attr :node

    def initialize(node)
      @node = node
    end

  end

  class AssertionException < NodeException
    def initialize(node, target_description)
      @node = node
      @target_description = target_description
    end
  end

  class NoSuchNameException < RuntimeError
    def initialize(name, type)
      @name, @type = name, type
    end
    def to_s
      t.assignment.no_such_name(@name, @type).to_s
    end
  end

  class ExpectedNotMetException < AssertionException
    def to_s
      t.assertions.fail.expected(
                @node.integer_val,
                @node.name_val,
                @node.type_val,
                @target_description).to_s
    end
  end

  class PermittedExceededException < AssertionException
    def to_s
      t.assertions.fail.permitted(
                @node.integer_val,
                @node.name_val,
                @node.type_val,
                @target_description).to_s
    end
  end

end
