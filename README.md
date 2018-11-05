# Rails Inject

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_inject', :git => 'https://github.com/mh-eh-gh/rails_inject.git'
```

And then execute:

    $ bundle

## Usage

Inherit a class from this to serve as an interface and define empty method blocks to implement in a concrete class.

Any `< RailsInject::Injectable` class will check the implementation contract on a `.new` invocation. If it fails, then an exception is thrown.

An implementable interface class would take the form of

```ruby
class MyClient < RailsInject::Injectable
  def some_interface_method(id)
  end
end

# Implementation

class MyClientImplementation < MyClient

  attr_accessor :url

  def initialize(config)
    @url = config[:url]
  end

  def some_interface_method(id)
    puts "Implementing #{id}"
  end
end
```

To wire up the implementation, configure a provider in your Rails project and use a configuration such as

```ruby
# config values for each provided class

my_client_config = { url: 'http://something.com' }

RailsInject::Provider.register do |provider|
   provider.add('MyClient', MyClientImplementation.new(my_client_config))
   # Register by class reference
   provider.add(MyModule::MyClient, MyModule::MyClientImplementation.new(my_client_config))
end
```

as an initializer.

Currently, no factories are available. To provide a configured container, use the following call in any dependent class:

```ruby
# Provide by literal class name
@my_client = RailsInject::Provider.provide('MyClient')

# Provide by class reference
@my_client = RailsInject::Provider.provide(MyModule::MyClient)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/injector.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
