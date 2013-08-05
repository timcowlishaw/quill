module Quill
  class Factory
    attr_reader :feature

    def initialize(klass, arguments={})
      @feature = arguments.fetch(:feature)
      @dependencies = arguments[:dependencies] || []
      @curried = arguments[:curried]
      @klass = klass
    end

    def call(container)
      curried? ? construct_curried_proc(container) : construct_instance(container)
    end

    private
      attr_reader :klass, :dependencies

      def curried?
        !!@curried
      end


      def construct_instance(container, args=[])
        arguments = fulfilled_dependencies(container) + args
        @instance ||= klass.new(*arguments)
      end

      def construct_curried_proc(container)
        ->(*args) { construct_instance(container, args) }
      end

      def fulfilled_dependencies(container)
        dependencies.map { |dep| container[dep] }
      end
  end
end
