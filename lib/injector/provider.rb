module Injector
  class Provider

    def self.register
      yield(self)
    end

    @@provided = {}

    def self.add(name, implementation)
      Object.const_get(name.to_s).new(
        type: implementation
      )
      @@provided[name.to_s] = implementation
    end

    def self.provide(name)
      @@provided[name.to_s]
    end

    def self.clear
      @@provided = {}
    end
  end
end