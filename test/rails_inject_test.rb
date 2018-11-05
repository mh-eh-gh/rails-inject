require "test_helper"

class RailsInjectTest < Minitest::Test

  def setup
    ::RailsInject::Provider.clear
    @my_client_config = { url: 'http://something.com' }
  end

  def test_that_it_has_a_version_number
    refute_nil ::RailsInject::VERSION
  end

  def test_inject_adds_a_provided_class_by_name

    assert_nil ::RailsInject::Provider.provide('MyClient')
    assert_nil ::RailsInject::Provider.provide(MyClient)

    ::RailsInject::Provider.register do |provider|
      provider.add('MyClient', MyClientImplementation.new(@my_client_config))
    end
    refute_nil ::RailsInject::Provider.provide('MyClient')
    refute_nil ::RailsInject::Provider.provide(MyClient)
  end

  def test_inject_adds_a_provided_class_by_reference

    assert_nil ::RailsInject::Provider.provide('MyClient')
    assert_nil ::RailsInject::Provider.provide(MyClient)

    ::RailsInject::Provider.register do |provider|
      provider.add(MyClient, MyClientImplementation.new(@my_client_config))
    end
    client = ::RailsInject::Provider.provide('MyClient')
    refute_nil client
    assert_equal client.some_interface_method('abc'), "Implementing abc"

    client = ::RailsInject::Provider.provide(MyClient)
    assert_equal client.some_interface_method('def'), "Implementing def"
    refute_nil client
  end

  def test_inject_throws_exception_when_method_not_implemented

    assert_nil ::RailsInject::Provider.provide('MyIncompleteClientImplementation')
    assert_nil ::RailsInject::Provider.provide(MyIncompleteClientImplementation)

    ::RailsInject::Provider.register do |provider|
      assert_raises(::RailsInject::Injectable::InjectException) {
         provider.add('MyClient', MyIncompleteClientImplementation.new(@my_client_config))
      }
    end
  end

  def test_clear_provider
    ::RailsInject::Provider.register do |provider|
      provider.add(MyClient, MyClientImplementation.new(@my_client_config))
    end
    refute_nil ::RailsInject::Provider.provide('MyClient')
    ::RailsInject::Provider.clear
    assert_nil ::RailsInject::Provider.provide('MyClient')
  end
end
