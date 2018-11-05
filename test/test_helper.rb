$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "injector"

require "minitest/autorun"

class MyClient < Injector::Injectable
  def some_interface_method(id)
  end
end

class MyIncompleteClientImplementation < MyClient

  attr_accessor :url

  def initialize(config)
    @url = config[:url]
  end

  def some_other_interface_method
    puts "Hello"
  end
end

class MyClientImplementation < MyClient

  attr_accessor :url

  def initialize(config)
    @url = config[:url]
  end

  def some_interface_method(id)
    "Implementing #{id}"
  end
end
