require 'quill/unsatisfied_dependency_error'
require 'quill/no_factory_error'
module Quill
  class Container
    def initialize
      @singletons = {}
      @factories = {}
    end

    def register_singleton(feature, instance)
      @singletons[feature] = instance
    end

    def register_class(klass)
      raise NoFactoryError.new(klass) unless klass.respond_to?(:factory)
      factory = klass.factory
      @factories[factory.feature] = factory
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
      factory && factory.call(self)
    end
  end
end
