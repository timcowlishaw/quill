module Quill
  class UnsatisfiedDependencyError < RuntimeError
    def initialize(dependency)
      @dependency = dependency
      super
    end

    def message
      "No implementation for the feature #{dependency} is registered with the container."
    end

    attr_reader :dependency
  end
end
