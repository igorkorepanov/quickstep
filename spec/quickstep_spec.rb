# frozen_string_literal: true

RSpec.describe Quickstep do
  let(:operation) do
    Class.new do
      include Quickstep

      def call
        step step1
        step step2
      end

      private

      def step1
        Success(:ok)
      end

      def step2
        Success(:ok)
      end
    end
  end

  it 'returns success when all steps succeed' do
    result = operation.new.call
    expect(result).to be_success
    expect(result.value).to eq(:ok)
  end

  context 'with error in one of the steps' do
    let(:operation) do
      Class.new do
        include Quickstep

        def call
          step step1
          step step2
          step step3
        end

        private

        def step1
          Success(:first_step)
        end

        def step2
          Failure(:error_step)
        end

        def step3
          Success(:last_step)
        end
      end
    end

    it 'halts execution on failure and returns the error' do
      result = operation.call
      expect(result).to be_failure
      expect(result.value).to eq(:error_step)
    end
  end

  context 'with another operation' do
    let(:operation) do
      second_operation

      Class.new do
        include Quickstep

        def call
          step step1
          step SecondOperation.call
        end

        private

        def step1
          Success(:ok)
        end
      end
    end

    let(:second_operation) do
      stub_const('SecondOperation', Class.new do
        include Quickstep

        def call
          Success(:second_operation_result)
        end
      end)
    end

    it 'executes steps in the correct order' do
      result = operation.call
      expect(result).to be_success
      expect(result.value).to eq(:second_operation_result)
    end
  end
end
