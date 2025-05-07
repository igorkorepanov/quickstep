# frozen_string_literal: true

require_relative 'quickstep/version'
require_relative 'quickstep/result'

module Quickstep
  include Quickstep::Result

  def self.included(base)
    base.extend(ClassMethods)
    base.prepend(InstanceMethods)
  end

  module ClassMethods
    def call(*args)
      catch :halt do
        new.call(*args)
      end
    end
  end

  module InstanceMethods
    def call(*args)
      catch :halt do
        super
      end
    end
  end

  def step(result)
    if result.success?
      result
    else
      throw :halt, result
    end
  end
end
