class TestClient < MiniTest::Unit::TestCase 
  def setup
    @client = Client.new('c664cbdc-6b11', 'aruprakshit@rocketmail.com', 'arupws1987')
  end

  def test_invalid_resource_access
    assert_raises(RuntimeError) { @client.resource_lists_to_access(2) }
  end

  def test_valid_resource_access
    assert_kind_of String, @client.resource_lists_to_access(1)
  end

  def test_make_url_must_not_accept_any_argument_except_string
    assert_raises(TypeError) { @client.send(:make_url, nil) }
  end

  def test_invalid_action_requested_by_client
    assert_nil @client.action_want_to_perform('0'), nil
  end

  def test_invalid_action_requested_by_client
    refute_nil @client.action_want_to_perform('1'), nil
  end
end
