Given(/^I have a factory with a named dependency$/) do
  @container = Quill::Container.new
  @feature_class = Struct.new(:dependency) do
    extend Quill::DSL
    provides :feature
    depends :dependency
  end
  @container.register_class(@feature_class)
end

Given(/^I have a curried factory with a named dependency$/) do
  @container = Quill::Container.new
  @feature_class = Struct.new(:dependency, :argument) do
    extend Quill::DSL
    provides :feature
    depends :dependency
    curried
  end
  @container.register_class(@feature_class)
end

When(/^I satisfy the named dependency with a singleton$/) do
  @dependency = Object.new
  @container.register_singleton(:dependency, @dependency)
end

When(/^I call the factory$/) do
  @feature = @container[:feature]
end

When(/^I satisfy the named dependency with another factory that has no dependencies$/) do
  @dependency_class = Class.new do
    extend Quill::DSL
    provides :dependency
  end
  @container.register_class(@dependency_class)
end

When(/^I satisfy the named dependency with another factory that has a dependency$/) do
  @dependency_class = Struct.new(:transitive_dependency) do
    extend Quill::DSL
    provides :dependency
    depends :transitive_dependency
  end
  @container.register_class(@dependency_class)
end

When(/^I satisfy that dependency with a singleton$/) do
  @transitive_dependency = Object.new
  @container.register_singleton(:transitive_dependency, @transitive_dependency)
end

When(/^I call the returned proc with additional arguments$/) do
  @argument = Object.new
  @feature = @container[:feature][@argument]
end

Then(/^the factory should receive the singleton instance of its dependency$/) do
  expect(@feature.dependency).to be == @dependency
end

Then(/^the factory should receive an instance created by the dependency factory$/) do
  expect(@feature.dependency).to be_instance_of(@dependency_class)
end

Then(/^the dependency factory should receive the singleton instance of its dependency$/) do
  expect(@feature.dependency.transitive_dependency).to be == @transitive_dependency
end

Then(/^the factory should receive the singleton dependency and the additional arguments$/) do
  expect(@feature.dependency).to be == @dependency
  expect(@feature.argument).to be == @argument
end
