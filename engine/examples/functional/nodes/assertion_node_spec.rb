require_relative './spec_helper.rb'

module Codiphi
  describe AssertionNode do
    describe "gather_assertions" do
      it "adds itself to list" do
        node = Node :assertion, "expects 99 pants :foo"
        _, list = node.gather_assertions({}, [])
        list.should_not be_nil
        list.should be_include node
      end

      it "doesn't modify original list" do
        node = Node :assertion, "expects 99 pants :foo"
        original_list = []
        node.gather_assertions({}, original_list)
        original_list.should be_empty
      end
    end

    it "adds error if no variable not declared" do
      node = Node :assertion, "expects 99 pants :foo"
      namespace, errors = node.gather_declarations(Namespace.new, [])
      errors.should_not be_empty
    end

    describe "named_type_values" do
      it "returns the named and type values" do
        Node(:assertion, "expects 99 pants :foo")
        .named_type_values.should == ["foo", "pants"]
      end
    end
  end
end
