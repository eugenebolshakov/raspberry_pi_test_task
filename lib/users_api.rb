require "bundler"
Bundler.setup(:default)

require "sinatra/base"

module UsersAPI
  require "./lib/users_api/json_api"
  require "./lib/users_api/repository"
  require "./lib/users_api/errors"

  def self.setup
    Repository.setup(ENV.fetch("DB_URL"))
  end

  class App < Sinatra::Base
    get "/users", provides: "json" do
      json_api.list_users
    end

    post "/users", provides: "json" do
      user_id = json_api.create_user(request.body.read)
      status(201)
      headers("Location" => "#{request.scheme}://#{request.host}/user/#{user_id}")
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
      halt(401, "API key is missing or invalid") unless request.env["HTTP_X_API_KEY"] == ENV.fetch("API_KEY")
      json_api.delete_user(params[:id])
      status(204)
    end

    error InvalidRequest do
      status(400)
      json_api.error(env['sinatra.error'])
    end

    error NotFound do
      status(404)
    end

    private

    def json_api
      @json_api ||= JSONAPI.new(db_url: ENV.fetch("DB_URL"))
    end

    run! if app_file == $0
  end
end
