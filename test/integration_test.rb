require "minitest/autorun"
require "bundler/setup"
require "rack/test"
require "json"

class IntegrationTest < Minitest::Test
  def test_list_users
    api.get("/users.json")
    expected = { data: [] }
    assert_equal expected.to_json, api.last_response.body
  end

  def api
    @api ||= Rack::Test::Session.new(Rack::MockSession.new(app))
  end

  def app
    Rack::Builder.new.run(lambda { |env|
      [
        200,
        { "Content-Type" => "application/json" },
        %W{{"data": []}}
      ]
    })
  end
end
