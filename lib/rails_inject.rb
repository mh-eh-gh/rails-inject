require "rails_inject/version"
require "rails_inject/provider"

module RailsInject
  # A simple DI container
  #
  # Usage: Inherit a class from this to serve as an interface and define empty
  # method blocks to implement in a concrete class.
  #
  # Any `< Injectable` class will check the implementation contract on a `.new`
  # invocation. If it fails, then an exception is thrown.
  #
  # Example:
  # `class SomeInterface < Injectable
  #   def some_method; end
  #  end`
  #
  # `class SomeClass < SomeInterface
  #   def some_method # implementation here
  #   end
  #  end`
  #
  class Injectable
    class InjectException < StandardError; end

    def initialize(type:)
      verify_type(type)
    end

    private

    # Verify that the type invoked meets the method requirements of the parent class (interface)
    # @todo also check method signature parity
    # @todo verify method exists in concrete implementation during run-time
    #
    def verify_type(type)
      object_methods = Object.methods
      implemented_methods = type.public_methods(false)
      container_methods = type.class.ancestors[1].instance_methods - object_methods
      errors = container_methods.map do |method|
        "[#{@injected}]: #{method} not implemented" unless implemented_methods.include?(method)
      end.compact
      raise Injectable::InjectException.new(errors.join('; ')) unless errors.empty?
    end
  end
end
