require "./test/test_helper"
require "rack/test"
require "./lib/users_api"

describe "Users API" do
  before do
    UsersAPI::Repository.setup(ENV["DB_URL"], force: true)
  end

  describe "GET to /users" do
    before do
      create_user
    end

    it "lists users" do
      perform_request(
        method: :get,
        path: "/users"
      )

      assert_response(
        status: 200,
        body: %Q`
          {
            "data": [
              {
                "type": "users",
                "id": "1",
                "attributes": {
                  "username": "user",
                  "email": "user@example.com" 
                }
              }
            ]
          }
        `
      )
    end
  end

  describe "POST to /users" do
    it "creates a user" do
      perform_request(
        method: :post,
        path: "/users", 
        body: %Q`
          {
            "data": {
              "type": "users",
              "attributes": { 
                "username": "user",
                "email": "user@example.com",
                "password": "pa$$w0rd"
              }
            }
          }
        `,
        headers: {
          "CONTENT_TYPE" => "application/vnd.api+json" 
        }
      )

      assert_response(
        status: 201,
        headers: { "Location" => "/user/1" },
        body: %Q`
          {
            "data": {
              "type": "users",
              "id": "1",
              "attributes": {
                "username": "user",
                "email": "user@example.com" 
              }
            }
          }
        `
      )

      assert_users([
        {
          id: "1",
          username: "user",
          email: "user@example.com"
        }
      ])
    end

    it "handles invalid JSON" do
      perform_request(
        method: :post,
        path: "/users", 
        body: "NOT-JSON"
      )

      assert_response(
        status: 400,
        body: %Q`
          {
            "errors": [
              {
                "title": "UsersAPI::InvalidRequest",
                "detail": "767: unexpected token at 'NOT-JSON'"
              }
            ]
          }
        `
      )
    end

    it "handles invalid data" do
      perform_request(
        method: :post,
        path: "/users", 
        body: %Q`
          {
            "data": {
              "type": "users",
              "attributes": { 
                "username": "",
                "email": "",
                "password": ""
              }
            }
          }
        `,
        headers: {
          "CONTENT_TYPE" => "application/vnd.api+json" 
        }
      )

      assert_response(
        status: 400,
        body: %Q`
          {
            "errors": [
              {
                "title": "UsersAPI::InvalidRequest",
                "detail": "username is not present, email is not present, password is not present"
              }
            ]
          }
        `
      )
    end
  end

  describe "GET to /user/:id" do
    before do
      create_user
    end

    it "returns user" do
      perform_request(
        method: :get,
        path: "/user/1"
      )

      assert_response(
        status: 200,
        body: %Q`
          {
            "data": {
              "type": "users",
              "id": "1",
              "attributes": {
                "username": "user",
                "email": "user@example.com" 
              }
            }
          }
        `
      )
    end
  end

  describe "PATCH to /user/:id" do
    before do
      create_user
    end

    it "updates user" do
      perform_request(
        method: :patch,
        path: "/user/1", 
        body: %Q`
          {
            "data": {
              "type": "users",
              "id": "1",
              "attributes": { 
                "username": "new-name"
              }
            }
          }
        `,
        headers: { 
          "CONTENT_TYPE" => "application/vnd.api+json" 
        }
      )

      assert_response(
        status: 200,
        body: %Q`
          {
            "data": {
              "type": "users",
              "id": "1",
              "attributes": {
                "username": "new-name",
                "email": "user@example.com" 
              }
            }
          }
        `
      )

      assert_users([
        {
          id: "1",
          username: "new-name",
          email: "user@example.com"
        }
      ])
    end
  end

  describe "DELETE to /user/:id" do
    before do
      create_user
    end

    it "deletes user" do
      perform_request(
        method: :delete,
        path: "/user/1",
        headers: {
          "X-API-KEY" => API_KEY
        }
      )

      assert_response(
        status: 204,
        body: ""
      )

      assert_users([])
    end
  end

  def perform_request(params)
    if params[:headers]
      params[:headers].each do |header, value|
        api.header(header, value)
      end
    end
    args = [params.fetch(:method), params.fetch(:path)]
    args << params[:body] unless params.fetch(:method) == :get
    api.public_send(*args)
  end

  def assert_response(params)
    assert_equal params.fetch(:status), api.last_response.status
    if params.fetch(:body) == ""
      assert_equal "", api.last_response.body
    else
      assert_equal JSON.parse(params.fetch(:body)), JSON.parse(api.last_response.body)
    end
    if params[:headers]
      params[:headers].each do |header, value|
        assert_equal value, api.last_response.headers[header]
      end
    end
  end

  def assert_users(users_data)
    perform_request(method: :get, path: "/users")
    assert_response(
      status: 200,
      body: {
        data: users_data.map { |user|
          {
            type: "users",
            id: user.fetch(:id),
            attributes: {
              username: user.fetch(:username),
              email: user.fetch(:email)
            }
          }
        }
      }.to_json
    )
  end

  def create_user
    perform_request(
      method: :post,
      path: "/users", 
      body: %Q`
        {
          "data": {
            "type": "users",
            "attributes": { 
              "username": "user",
              "email": "user@example.com",
              "password": "pa$$w0rd"
            }
          }
        }
      `,
      headers: { 
        "CONTENT_TYPE" => "application/vnd.api+json"
      }
    )
  end

  def api
    @api ||= Rack::Test::Session.new(Rack::MockSession.new(UsersAPI::App))
  end
end
