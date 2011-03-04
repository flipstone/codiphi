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

    it "adds error if no variable declared" do
      node = Node :assertion, "expects 99 pants :foo"
      namespace, errors = node.gather_declarations(Namespace.new, [])
      errors.should_not be_empty
    end

    describe "gather_declarations" do
      it "throws error on assignment without declaration" do
        node = Node :assertion, "expects 99 pants :foo"
        _, errors = node.gather_declarations(Namespace.new, [])
        errors.first.class.should == Codiphi::NoSuchNameException
      end

      it "doesn't throws error on assignment with declaration" do
        node = Node :assertion, "expects 99 pants :foo"
        _, errors = node.gather_declarations(
          Namespace.new.add_named_type('foo','pants'), []
        )
        errors.should be_empty
      end

      it "throws an error when a name in an option list is not declared" do
        node = Node :assertion, "expects 99 pants [:foo :bar]"
        _, errors = node.gather_declarations(
          Namespace.new.add_named_type('foo','pants'), []
        )
        errors.first.class.should == Codiphi::NoSuchNameException
      end

      it "doesn't throw an error when aall names in an option list are declared" do
        node = Node :assertion, "expects 99 pants [:foo :bar]"
        _, errors = node.gather_declarations(
          Namespace.new.add_named_type('foo','pants')
                       .add_named_type('bar','pants'),
          []
        )
        errors.should be_empty
      end
    end

    describe "named_type_values" do
      it "returns the named and type values" do
        Node(:assertion, "expects 99 pants :foo")
        .named_type_values.should == ["foo", "pants"]
      end
    end
  end
end
