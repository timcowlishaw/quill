require 'spec_helper'
require 'quill/container'
require 'quill/unsatisfied_dependency_error'

describe Quill::Container do
  subject(:container) { Quill::Container.new }
  let(:instance) { double(:instance) }
  let(:name) { double(:factory) }

  describe "registering and returning singletons" do
    it "returns the registed instance" do
      container.register_singleton(name, instance)
      expect(container[name]).to be(instance)
    end
  end

  describe "registering and constructing classes" do
    context "registering a class with a factory" do
      it "calls the factory with itself when the named feature is requested" do
        klass = double(:class)
        instance = double(:instance)
        factory = double(:factory, :feature => :feature_name)
        expect(klass).to receive(:factory).and_return(factory)
        container.register_class(klass)
        expect(factory).to receive(:call).with(container).and_return(instance)
        expect(container[:feature_name]).to be == instance
      end
    end


    context "registering a class without a factory" do
      it "raises an error" do
        klass = double(:class)
        expect {
          container.register_class(klass)
        }.to raise_error(Quill::NoFactoryError)
      end
    end
  end
end
