require 'spec_helper'
require 'quill/dsl'
describe "Quill::DSL" do

  let(:factory) { double(:factory) }

  subject(:extending_class) {
    Class.new do
      extend Quill::DSL
    end
  }

  before(:each) do
    allow(Quill::Factory).to receive(:new).and_return(factory)
  end

  context "when a provided feature name is not supplied" do
    it "raises an error when the factory is accessed" do
      expect {
        extending_class.factory
      }.to raise_error
    end
  end

  context "when a provided feature name is supplied" do
    context "when no dependencies are supplied" do
      it "exposes a Quill factory wrapping the extended class with the specified feature name and no dependencies" do
        expect(Quill::Factory).to receive(:new).with(extending_class, :feature => :feature_name, :dependencies => []).and_return(factory)
        extending_class.instance_eval do
          extend Quill::DSL
          provides :feature_name
        end
        expect(extending_class.factory).to be == factory
      end
    end

    context "when dependencies are supplied" do
      it "exposes a Quill factory wrapping the extended class with the specified feature name and the_specified dependencies" do
        expect(Quill::Factory).to receive(:new).with(extending_class, :feature => :feature_name, :dependencies => [:dependency_1, :dependency_2]).and_return(factory)
        extending_class.instance_eval do
          extend Quill::DSL
          provides :feature_name
          depends :dependency_1, :dependency_2
        end
        expect(extending_class.factory).to be == factory
      end
    end
  end
end
