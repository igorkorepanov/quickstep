# frozen_string_literal: true

RSpec.describe Quickstep::Result do
  include described_class

  describe '#Success' do
    it 'returns a Success object with the given value' do
      result = Success(:ok)
      expect(result).to be_a(Quickstep::Result::Success)
      expect(result.value).to eq(:ok)
      expect(result).to be_success
      expect(result).not_to be_failure
    end

    it 'returns a Success object with an object as value' do
      object = { key: 'value' }
      result = Success(object)
      expect(result).to be_a(Quickstep::Result::Success)
      expect(result.value).to eq(object)
      expect(result).to be_success
      expect(result).not_to be_failure
    end

    it 'returns a Success object with multiple keys' do
      object = { key1: 'value1', key2: 'value2' }
      result = Success(object)
      expect(result).to be_a(Quickstep::Result::Success)
      expect(result.value).to eq(object)
      expect(result).to be_success
      expect(result).not_to be_failure
    end

    it 'returns the correct string representation' do
      result = Success(code: :ok, data: :data)
      if RUBY_VERSION >= '3.4'
        expect(result.inspect).to eq('Success({code: :ok, data: :data})')
      else
        expect(result.inspect).to eq('Success({:code=>:ok, :data=>:data})')
      end
    end

    it 'returns true for Success() with no arguments' do
      result = Success()
      expect(result).to be_success
      expect(result.inspect).to eq('Success(:ok)')
    end
  end

  describe '#Failure' do
    it 'returns a Failure object with the given value' do
      result = Failure(:error)
      expect(result).to be_a(Quickstep::Result::Failure)
      expect(result.value).to eq(:error)
      expect(result).to be_failure
      expect(result).not_to be_success
    end

    it 'returns a Failure object with an object as value' do
      object = { key: 'value' }
      result = Failure(object)
      expect(result).to be_a(Quickstep::Result::Failure)
      expect(result.value).to eq(object)
      expect(result).to be_failure
      expect(result).not_to be_success
    end

    it 'returns a Failure object with multiple keys' do
      object = { key1: 'value1', key2: 'value2' }
      result = Failure(object)
      expect(result).to be_a(Quickstep::Result::Failure)
      expect(result.value).to eq(object)
      expect(result).to be_failure
      expect(result).not_to be_success
    end

    it 'returns the correct string representation' do
      result = Failure(code: :error, data: :data)
      if RUBY_VERSION >= '3.4'
        expect(result.inspect).to eq('Failure({code: :error, data: :data})')
      else
        expect(result.inspect).to eq('Failure({:code=>:error, :data=>:data})')
      end
    end

    it 'returns a failure result when called without arguments' do
      result = Failure()
      expect(result).to be_failure
      expect(result.inspect).to eq('Failure(:error)')
    end
  end
end
