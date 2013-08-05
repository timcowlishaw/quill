module Quill
  class Factory
    attr_reader :feature

    def initialize(klass, arguments={})
      @feature = arguments.fetch(:feature)
      @dependencies = arguments[:dependencies] || []
      @klass = klass
    end

    def call(container)
      return @instance if @instance
      args = dependencies.map { |dep| container[dep] }
      @instance = klass.new(*args)
    end

    private
      attr_reader :klass, :dependencies
  end
end
