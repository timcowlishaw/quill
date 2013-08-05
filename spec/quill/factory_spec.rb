require 'spec_helper'
require 'quill/factory'
describe Quill::Factory do
  let(:feature_name) { double(:feature_name) }
  let(:klass) { double(:klass) }

  subject(:factory) { Quill::Factory.new(klass, :feature => feature_name )}

  describe "feature" do
    it "returns the feature name" do
      expect(factory.feature).to be == feature_name
    end
  end

  describe "call" do
    let(:container) { double(:container) }
    let(:instance) { double(:instance) }

    context "when the factory is not curried" do
      context "when the factory has no dependencies" do
        it "calls the class constructor with no arguments" do
          expect(klass).to receive(:new).and_return(instance)
          expect(factory.call(container)).to be == instance
        end
      end

      context "when the factory has dependencies" do
        let(:dependency_1) { double(:dependency_1) }
        let(:dependency_2) { double(:dependency_2) }

        subject(:factory) {
          Quill::Factory.new(klass, {
            :feature => feature_name,
            :dependencies => [:dependency_1, :dependency_2],
          })
        }

        it "calls the class constructor with the dependencies from the factory" do
          expect(container).to receive(:[]).with(:dependency_1).and_return(dependency_1)
          expect(container).to receive(:[]).with(:dependency_2).and_return(dependency_2)
          expect(klass).to receive(:new).with(dependency_1, dependency_2).and_return(instance)
          expect(factory.call(container)).to be == instance
        end
      end

      it "memoizes the constructed instance of the class" do
        allow(klass).to receive(:new) { Object.new }
        first = factory.call(container)
        second = factory.call(container)
        expect(first).to eq(second)
      end
    end

    context "when the factory is curried" do
      context "when the factory has no dependencies" do
        subject(:factory) {
          Quill::Factory.new(klass, {
            :feature => feature_name,
            :curried => true,
          })
        }

        it "returns a proc which calls the class constructor with no arguments" do
          the_proc = factory.call(container)
          expect(klass).to receive(:new).and_return(instance)
          expect(the_proc.call).to be == instance
        end
      end

      context "when the factory has dependencies" do
        let(:dependency_1) { double(:dependency_1) }
        let(:dependency_2) { double(:dependency_2) }
        let(:additional_arg_1) { double(:additional_arg_1) }
        let(:additional_arg_2) { double(:additional_arg_2) }

        subject(:factory) {
          Quill::Factory.new(klass, {
            :feature => feature_name,
            :dependencies => [:dependency_1, :dependency_2],
            :curried => true
          })
        }

        it "calls the class constructor with the dependencies from the factory" do
          expect(container).to receive(:[]).with(:dependency_1).and_return(dependency_1)
          expect(container).to receive(:[]).with(:dependency_2).and_return(dependency_2)
          the_proc = factory.call(container)
          expect(klass).to receive(:new).
            with(dependency_1, dependency_2, additional_arg_1, additional_arg_2).
            and_return(instance)
          result = the_proc.call(additional_arg_1, additional_arg_2)
          expect(result).to be == instance
        end
      end

      it "memoizes the constructed instance of the class" do
        allow(klass).to receive(:new) { Object.new }
        first = factory.call(container)
        second = factory.call(container)
        expect(first).to eq(second)
      end
    end
  end
end
