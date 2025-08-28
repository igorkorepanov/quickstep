# frozen_string_literal: true

module Quickstep
  module Result
    class Success
      attr_reader :value

      def initialize(value = nil)
        @value = value
      end

      def success?
        true
      end

      def failure?
        false
      end

      def inspect
        value.nil? ? 'Success()' : "Success(#{value.inspect})"
      end

      def ==(other)
        other.is_a?(Success) && other.value == value
      end
    end

    class Failure
      attr_reader :value

      def initialize(value = nil)
        @value = value
      end

      def success?
        false
      end

      def failure?
        true
      end

      def inspect
        value.nil? ? 'Failure()' : "Failure(#{value.inspect})"
      end

      def ==(other)
        other.is_a?(Failure) && other.value == value
      end
    end

    def Success(value = nil)
      Success.new(value)
    end

    def Failure(value = nil)
      Failure.new(value)
    end
  end
end
