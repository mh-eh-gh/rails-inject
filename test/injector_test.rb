require "test_helper"

class InjectorTest < Minitest::Test

  def setup
    ::Injector::Provider.clear
    @my_client_config = { url: 'http://something.com' }
  end

  def test_that_it_has_a_version_number
    refute_nil ::Injector::VERSION
  end

  def test_inject_adds_a_provided_class_by_name

    assert_nil ::Injector::Provider.provide('MyClient')
    assert_nil ::Injector::Provider.provide(MyClient)

    ::Injector::Provider.register do |provider|
      provider.add('MyClient', MyClientImplementation.new(@my_client_config))
    end
    refute_nil ::Injector::Provider.provide('MyClient')
    refute_nil ::Injector::Provider.provide(MyClient)
  end

  def test_inject_adds_a_provided_class_by_reference

    assert_nil ::Injector::Provider.provide('MyClient')
    assert_nil ::Injector::Provider.provide(MyClient)

    ::Injector::Provider.register do |provider|
      provider.add(MyClient, MyClientImplementation.new(@my_client_config))
    end
    client = ::Injector::Provider.provide('MyClient')
    refute_nil client
    assert_equal client.some_interface_method('abc'), "Implementing abc"

    client = ::Injector::Provider.provide(MyClient)
    assert_equal client.some_interface_method('def'), "Implementing def"
    refute_nil client
  end

  def test_inject_throws_exception_when_method_not_implemented

    assert_nil ::Injector::Provider.provide('MyIncompleteClientImplementation')
    assert_nil ::Injector::Provider.provide(MyIncompleteClientImplementation)

    ::Injector::Provider.register do |provider|
      assert_raises(::Injector::Injectable::InjectException) {
         provider.add('MyClient', MyIncompleteClientImplementation.new(@my_client_config))
      }
    end
  end

  def test_clear_provider
    ::Injector::Provider.register do |provider|
      provider.add(MyClient, MyClientImplementation.new(@my_client_config))
    end
    refute_nil ::Injector::Provider.provide('MyClient')
    ::Injector::Provider.clear
    assert_nil ::Injector::Provider.provide('MyClient')
  end
end
