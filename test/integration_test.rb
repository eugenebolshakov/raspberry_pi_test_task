require "minitest/autorun"
require "./api"
Bundler.setup(:default, :test)
require "rack/test"

class IntegrationTest < Minitest::Test
  def test_list_users
    api.get("/users")
    expected = JSONAPI.render(data: []).to_json
    assert_equal expected, api.last_response.body
  end

  def api
    @api ||= Rack::Test::Session.new(Rack::MockSession.new(app))
  end

  def app
    Sinatra::Application
  end
end
