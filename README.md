# Rails Inject

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/injector`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails-inject', :git => 'https://github.com/mh-eh-gh/rails-inject.git'
```

And then execute:

    $ bundle

## Usage

Inherit a class from this to serve as an interface and define empty method blocks to implement in a concrete class.

Any `< Injector::Injectable` class will check the implementation contract on a `.new` invocation. If it fails, then an exception is thrown.

An implementable interface class would take the form of

```ruby
class MyClient < Injector::Injectable
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

Injector::Provider.register do |provider|
   provider.add('MyClient', MyClientImplementation.new(my_client_config))
   # Register by class reference
   provider.add(MyModule::MyClient, MyModule::MyClientImplementation.new(my_client_config))
end
```

as an initializer.

Currently, no factories are available. To provide a configured container, use the following call in any dependent class:

```ruby
# Provide by literal class name
@my_client = Injector::Provider.provide('MyClient')

# Provide by class reference
@my_client = Injector::Provider.provide(MyModule::MyClient)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/injector.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
