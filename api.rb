require "bundler"
Bundler.setup(:default)
require "sinatra"

require "./lib/user"
require "./lib/jsonapi"

$API = JSONAPI.new([])

get "/users", provides: "json" do
  $API.list_users
end

post "/users", provides: "json" do
  user_id = $API.create_user(request.body.read)
  status(201)
  headers("Location" => "/user/#{user_id}")
  $API.get_user(user_id)
end

get "/user/:id", provides: "json" do
  $API.get_user(params[:id])
end

patch "/user/:id", provides: "json" do
  $API.update_user(params[:id], request.body.read)
  $API.get_user(params[:id])
end

delete "/user/:id", provides: "json" do
  halt(401, "API key is missing or invalid") unless request.env["X-API-KEY"] == ENV["API_KEY"]
  $API.delete_user(params[:id])
  status(204)
end
