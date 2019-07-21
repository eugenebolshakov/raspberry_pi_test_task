require "minitest/autorun"
require "./api"
Bundler.setup(:default, :test)
require "rack/test"
require "json"

class IntegrationTest < Minitest::Test
  def test_list_users
    api.get("/users")
    expected = { data: [] }
    assert_equal expected.to_json, api.last_response.body
  end

  def api
    @api ||= Rack::Test::Session.new(Rack::MockSession.new(app))
  end

  def app
    Sinatra::Application
  end
end
