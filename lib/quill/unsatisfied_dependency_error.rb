module Quill
  class UnsatisfiedDependencyError < RuntimeError
    def initialize(dependency)
      @dependency = dependency
      super
    end

    attr_reader :dependency
  end
end
