require 'quill/factory'
module Quill
  module DSL

    def factory
      raise "You must specify a feature provided by the class" unless provided_feature
      @factory ||= Quill::Factory.new(self, {
        :feature => provided_feature,
        :dependencies => @dependencies || [],
        :curried => curried?
      })
    end

    def provides(feature_name)
      @provided_feature = feature_name
    end

    def depends(*dependency_names)
      @dependencies = dependency_names
    end

    def curried(value = true)
      @curried = value
    end

    private
      attr_reader :provided_feature

      def curried?
        !!@curried
      end
  end
end
