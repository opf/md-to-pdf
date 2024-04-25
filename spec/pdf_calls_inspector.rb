module PDF
  class Inspector
    class Calls < Inspector
      attr_reader :calls

      def initialize
        super
        @calls = []
      end

      def method_missing(*args)
        @calls << args
      end

      def respond_to_missing?(*)
        true
      end

      def respond_to?(*)
        true
      end
    end
  end
end
