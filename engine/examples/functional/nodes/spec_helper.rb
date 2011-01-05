require_relative '../../spec_helper.rb'

def literal_node(value, parent=nil)
  node = nil
  case value
  when Fixnum 
    node = Codiphi::IntegerNode.new(value.to_s, 0..value.to_s.length)
  when String, Char
    node = Codiphi::LiteralNode.new(value.to_s, 0..value.length)
  end
  node.parent = parent  
  node
end

def cost_assignment_mock(opval, valueval, parent=nil)
  input = "#{opval}#{valueval}"
  node = Codiphi::CostAssignmentNode.new(input, 0..input.length)
  node.parent = parent
  node.stubs(:assignment_operator).returns(literal_node(opval, node))
  node.stubs(:value).returns(literal_node(valueval, node))
  node
end

def assignment_mock(opval, typeval, valueval, parent=nil)
  input = "#{opval}#{typeval}#{valueval}"
  node = Codiphi::AssignmentNode.new(input, 0..input.length)
  node.parent = parent
  node.stubs(:assignment_operator).returns(literal_node(opval, node))
  node.stubs(:type).returns(literal_node(typeval, node))
  node.stubs(:value).returns(literal_node(valueval, node))
  node
end

def declaration_mock(typeval, nameval, parent=nil)
  input = "#{typeval}#{nameval}"
  node = Codiphi::DeclarationNode.new(input, 0..input.length)
  node.parent = parent
  node.stubs(:type).returns(literal_node(typeval, node))
  node.stubs(:name).returns(literal_node(nameval, node))
  node
end

def condition_mock(opval, typeval, nameval, assertion_node, parent=nil)
  input = "#{opval}#{typeval}#{nameval}"
  opnode = literal_node(opval)
  typenode = literal_node(typeval)
  namenode = literal_node(nameval)

  node = Codiphi::ConditionNode.new(input, 0..input.length, 
    [opnode, typenode, namenode, assertion_node])

  opnode.parent = node
  typenode.parent = node
  namenode.parent = node
  assertion_node.parent = node

  node.parent = parent
  node.stubs(:assignment_operator).returns(opnode)
  node.stubs(:type).returns(typenode)
  node.stubs(:name).returns(namenode)
  node
end

def assertion_mock(opval, intval, typeval, nameval, parent=nil)
  input = "#{opval}#{intval}#{nameval}"
  node = Codiphi::AssertionNode.new(input, 0..input.length)
  node.parent=parent
  node.stubs(:op).returns(literal_node(opval, node))
  node.stubs(:integer).returns(literal_node(intval, node))
  node.stubs(:type).returns(literal_node(typeval, node))
  node.stubs(:name).returns(literal_node(nameval, node))
  node
end

