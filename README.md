# Quill

Quill helps you write cleaner, clearer ruby code, by disentangling the business
of specifying a classes dependencies from the business of constructing and
supplying them.

## Installation

Add this line to your application's Gemfile:

    gem 'quill'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quill

## Usage

Extend your classes with the Quill DSL in order to specify their dependencies.
Each class must specify the name of the feature it implements, and can
optionally specify a list of features on which it depends:

```ruby
require 'quill/dsl'
class UIController
  extend Quill::DSL

  #The name of the feature implemented
  provides :ui_controller

  #The names of the features we depend on. These will be passed in order as
arguments to the constructor.
  depends [:logger, :display]

  def initialize(logger, display)
    @logger = logger
    @display = display
  end

  def run!
    #...do things with the logger and display
  end
end
```

You can then construct a Quill Container, and register all your Quill classes
with them:

```ruby
  require 'quill/container'
  container = Quill::Container.new
  container.register_class(UIController)

  #register implementation for every feature, so that the container can resolve
the dependencies:
  container.register_class(Logger)

  #You can also register single instances as named features:
  container.register_singleton(:display, STDOUT)

```

Finally, ask the container for the implementation of a feature, this will
automatically resolve all the dependencies and construct the entire object
graph!

```ruby
  controller = container[:ui_controller]
  controller.run!
```

You can also lazily construct objects with a mixture of static dependencies and
other arguments, using the 'curried' option:

```ruby
  require 'quill/dsl'
  require 'quill/container'

  class InventoryDisplay
    extend Quill::DSL

    provides :inventory_display
    depends [:display]
    curried

    #the display dependency is injected, items is not.
    def initialize(display, items)
      @display = display
      @items = items
    end

    container = Quill::Container.new
    container.register_class(InventoryDisplay)

    display_builder_proc = container[:inventory_display]

    display_builder_proc.call(inventory) #=> Constructs and returns an instance
```

## Why?
  [Dependency
Injection](https://speakerdeck.com/bestie/improve-your-ruby-code-with-dependency-injection) is a fundamental pattern in object oriented programming, and is invaluable for making sure your code is testable and minimally coupled. However, it's often difficult to work out where the responsiblity for satisfying dependencies should happen. Quill takes care of this for you, with a simple, minimal framework for configuring your application's dependencies.

## Compatibility
  Tested with Ruby 1.9.3

## Still to come

  - Support for argument hashes
  - Support for Ruby 2.0 named arguments
  - Configurable instance memoization


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
