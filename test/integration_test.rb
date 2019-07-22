ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "./api"
Bundler.setup(:default, :test)
require "rack/test"

class IntegrationTest < Minitest::Test
  CONTENT_TYPE = "application/vnd.api+json"

  def test_api
    # POST /users
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

    id = location[/\/(\d+)$/, 1].to_i
    expected = %Q`
      {
        "data": {
          "type": "users",
          "id": "#{id}",
          "attributes": { "username": "user", "email": "user@example.com" }
        }
      }
    `
    assert_equal JSON.parse(expected), JSON.parse(api.last_response.body)

    # GET /users
    api.get("/users")
    assert_equal 200, api.last_response.status

    expected = %Q`
      {
        "data": [
          {
            "type": "users",
            "id": "#{id}",
            "attributes": { 
              "username": "user",
              "email": "user@example.com"
            }
          }
        ]
      }
    `
    assert_equal JSON.parse(expected), JSON.parse(api.last_response.body)

    # PATCH /user/:id
    api.patch("/user/#{id}", %Q`
      {
        "data": {
          "type": "users",
          "id": "#{id}",
          "attributes": {
            "username": "new-username"
          }
        }
      }
    `, { "CONTENT_TYPE" => CONTENT_TYPE })
    assert_equal 200, api.last_response.status

    expected = %Q`
      {
        "data": {
          "type": "users",
          "id": "#{id}",
          "attributes": { 
            "username": "new-username",
            "email": "user@example.com"
          }
        }
      }
    `
    assert_equal JSON.parse(expected), JSON.parse(api.last_response.body)

    # GET /user/:id
    api.get("/user/#{id}")
    assert_equal 200, api.last_response.status

    expected = %Q`
      {
        "data": {
          "type": "users",
          "id": "#{id}",
          "attributes": {
            "username": "new-username",
            "email": "user@example.com"
          }
        }
      }
    `
    assert_equal JSON.parse(expected), JSON.parse(api.last_response.body)
  end

  def api
    @api ||= Rack::Test::Session.new(Rack::MockSession.new(app))
  end

  def app
    Sinatra::Application
  end
end
