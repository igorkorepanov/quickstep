# frozen_string_literal: true

module Quickstep
  module Result
    class Success
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def success?
        true
      end

      def failure?
        false
      end

      def inspect
        "Success(#{value.inspect})"
      end
    end

    class Failure
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def success?
        false
      end

      def failure?
        true
      end

      def inspect
        "Failure(#{value.inspect})"
      end
    end

    def Success(value)
      Success.new(value)
    end

    def Failure(value)
      Failure.new(value)
    end
  end
end
