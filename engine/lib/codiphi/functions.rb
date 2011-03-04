module Codiphi
  module Functions
    def self.functions
      @functions ||= {}
    end

    def self.define_function(name, &block)
      functions[name] = block
    end

    def self.[](name)
      functions[name] || raise(UndefinedFunctionError, name.to_s)
    end

    def self.curry_data(data)
      CurryProxy.new data, self
    end

    class CurryProxy < Struct.new(:data, :functions)
      def [](name)
        -> *args do
          functions[name].call data, *args
        end
      end
    end

    class UndefinedFunctionError < StandardError

    end
  end
end

