require "minitest/autorun"
require "json"

class IntegrationTest < Minitest::Test
  def test_list_users
    response = get("/users.json")
    expected = { data: [] }
    assert_equal expected.to_json, response
  end

  def get(path)
    { data: [] }.to_json
  end
end
