require "minitest/autorun"
require "./api"
Bundler.setup(:default, :test)
require "rack/test"

class IntegrationTest < Minitest::Test
  CONTENT_TYPE = "application/vnd.api+json"

  def test_api
    api.get("/users")
    assert_equal 200, api.last_response.status

    expected = { data: [] }
    assert_equal expected.to_json, api.last_response.body

    resource = {
      data: {
        type: "users",
        attributes: { 
          username: "user",
          email: "user@example.com",
          password: "pa$$w0rd"
        }
      }
    }
    api.post("/users", resource.to_json, { "CONTENT_TYPE" => CONTENT_TYPE })
    assert_equal 201, api.last_response.status

    location = api.last_response.headers["Location"]
    assert_match /\/user\/\d+$/, location

    expected = {
      data: {
        type: "users",
        id: location[/\/(\d+)$/, 1].to_i,
        attributes: { username: "user", email: "user@example.com" },
        links: { self: location }
      }
    }
    assert_equal expected.to_json, api.last_response.body
  end

  def api
    @api ||= Rack::Test::Session.new(Rack::MockSession.new(app))
  end

  def app
    Sinatra::Application
  end
end
