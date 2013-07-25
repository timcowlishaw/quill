require 'quill/unsatisfied_dependency_error'
module Quill
  class Container
    def initialize
      @singletons = {}
      @factories = {}
    end

    def register_singleton(name, instance)
      @singletons[name] = instance
    end

    def register_factory(factory)
      @factories[factory.name] = factory
    end

    def [](name)
      instance = named_singleton(name) || instance_from_named_factory(name)
      instance or raise UnsatisfiedDependencyError.new(name)
    end

    private

    def named_singleton(name)
      @singletons[name]
    end

    def instance_from_named_factory(name)
      factory = @factories[name]
      factory && factory.call
    end
  end
end
