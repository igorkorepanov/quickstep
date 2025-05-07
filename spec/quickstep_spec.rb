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
        Success(:step_1_ok)
      end

      def step2
        Success(:step_2_ok)
      end
    end
  end
  let(:second_operation) do
    stub_const('SecondOperation', Class.new do
      include Quickstep

      def call
        step step1
        step step2
        step step3
      end

      private

      def step1
        Success(:ok)
      end

      def step2
        Failure(:second_operation_result)
      end

      def step3
        # it never executes
        Success(:ok)
      end
    end)
  end

  context 'when calling the operation as a class' do
    it 'returns success when all steps succeed' do
      result = operation.call
      expect(result).to be_success
      expect(result.value).to eq(:step_2_ok)
    end

    context 'with error in one of the steps' do
      let(:operation_with_failure) do
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
        result = operation_with_failure.call
        expect(result).to be_failure
        expect(result.value).to eq(:error_step)
      end
    end

    context 'with another operation' do
      let(:operation) do
        Class.new do
          include Quickstep

          def call
            step step1
            step SecondOperation.call
            step step3
          end

          private

          def step1
            Success(:ok)
          end

          def step3
            # it never executes
            Success(:ok)
          end
        end
      end

      before { second_operation }

      it 'executes steps in the correct order' do
        result = operation.call
        expect(result).to be_failure
        expect(result.value).to eq(:second_operation_result)
      end
    end
  end

  context 'when calling the operation as an instance' do
    it 'returns success when all steps succeed' do
      result = operation.new.call
      expect(result).to be_success
      expect(result.value).to eq(:step_2_ok)
    end

    context 'with error in one of the steps' do
      let(:operation_with_failure) do
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
            # it never executes
            Success(:last_step)
          end
        end
      end

      it 'halts execution on failure and returns the error' do
        result = operation_with_failure.new.call
        expect(result).to be_failure
        expect(result.value).to eq(:error_step)
      end
    end

    context 'with another operation' do
      let(:operation) do
        Class.new do
          include Quickstep

          def call
            step step1
            step SecondOperation.new.call
            step step3
          end

          private

          def step1
            Success(:ok)
          end

          def step3
            # it never executes
            Success(:ok)
          end
        end
      end

      before { second_operation }

      it 'executes steps in the correct order' do
        result = operation.new.call
        expect(result).to be_failure
        expect(result.value).to eq(:second_operation_result)
      end
    end
  end
end
