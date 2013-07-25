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

  describe "registering and constructing factories" do
    let(:factory) { double(:factory, :name => name, :call => instance) }

    it "returns the instance constructed by the factory" do
      container.register_factory(factory)
      expect(container[name]).to be(instance)
    end

    it "calls the corrsponding factory" do
      container.register_factory(factory)
      container[name]
      expect(factory).to have_received(:call)
    end

    it "raises an error if no implementation is available" do
      expect {
        container[:doesnt_exist]
      }.to raise_error { |error|
        expect(error).to be_a(Quill::UnsatisfiedDependencyError)
        expect(error.dependency).to be(:doesnt_exist)
      }

    end

    it "raises an error for the dependency that is missing when a transitive dependency is unsatisfied"

    it "memoizies the instance created by the factory"

    context "when the factory has dependencies" do
      let(:dependency_name) { double(:dependency_name) }
      let(:dependency_instance) { double(:dependency_instance) }
      let(:factory) { double(:factory, :name => name, :call => instance, :dependencies => [dependency_name])}

      it "calls the factory with the specified dependencies" do
        container.register_singleton(dependency_name, dependency_instance)
        container.register_factory(factory)
        container[name]
        expect(factory).to have_received(:call).with(dependency_instance)
      end

      context "when the factory is curried" do
        let(:factory) { double(:factory, :name => name, :call => instance, :dependencies => [dependency_name], :curried? => true)}
        let(:extra_arg_1) { double(:extra_arg_1) }
        let(:extra_arg_2) { double(:extra_arg_2) }

        it "returns a construct function partially applied with the specified dependencies" do
          container.register_factory(factory)
          callable = container[name]
          result = callable.call(extra_arg_1, extra_arg_2)
          expect(result).to be(instance)
          expects(factory).to have_received(call).with(dependency_instance, extra_arg_1, extra_arg_2)
        end
      end
    end
  end
end
