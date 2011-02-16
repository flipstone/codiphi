require_relative './spec_helper.rb'

module Codiphi
  describe AssertionNode do
    it "adds itself to passed context on transform" do
      node = assertion_mock("expects", 99, "foo", "pants")
      list = []
      node.gather_assertions({}, Namespace.new, list, true)
      list.should_not be_nil
      list.should be_include node
    end

    it "adds error if no variable not declared" do
      node = assertion_mock("expects", 99, "foo", "pants")
      namespace = node.gather_declarations(Namespace.new)
      namespace.should have_errors
    end

  end
end
