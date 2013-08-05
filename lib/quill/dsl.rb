require 'quill/factory'
module Quill
  module DSL

    def factory
      raise "You must specify a feature provided by the class" unless provided_feature
      @factory ||= Quill::Factory.new(self, :feature => provided_feature, :dependencies => @dependencies || [])
    end

    def provides(feature_name)
      @provided_feature = feature_name
    end

    def depends(*dependency_names)
      @dependencies = dependency_names
    end

    private
      attr_reader :provided_feature
  end
end
