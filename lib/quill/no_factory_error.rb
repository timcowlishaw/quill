module Quill
  class NoFactoryError < RuntimeError
    def initialize(klass)
      @klass = klass
    end

    def message
      "The class #{klass.name} cannot be registered with the container, as it does not extend Quill::DSL."
    end

    private
      attr_reader :klass
  end
end
