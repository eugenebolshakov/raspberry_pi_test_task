require "bundler"
Bundler.setup(:default)

require "sinatra"

module UsersAPI
  require "./lib/users_api/json_api"

  class App < Sinatra::Base
    get "/users", provides: "json" do
      json_api.list_users
    end

    post "/users", provides: "json" do
      user_id = json_api.create_user(request.body.read)
      status(201)
      headers("Location" => "/user/#{user_id}")
      json_api.get_user(user_id)
    end

    get "/user/:id", provides: "json" do
      json_api.get_user(params[:id])
    end

    patch "/user/:id", provides: "json" do
      json_api.update_user(params[:id], request.body.read)
      json_api.get_user(params[:id])
    end

    delete "/user/:id", provides: "json" do
      halt(401, "API key is missing or invalid") unless request.env["X-API-KEY"] == ENV["API_KEY"]
      json_api.delete_user(params[:id])
      status(204)
    end

    private

    def json_api
      @json_api ||= JSONAPI.new(db_uri: ENV.fetch("DB_URI"))
    end
  end
end
