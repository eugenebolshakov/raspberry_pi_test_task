require "bundler"
Bundler.setup(:default)
require "sinatra"

User = Struct.new(:id, :username, :email)

class JSONAPI
  def initialize(users = [])
    @users = []
  end

  def list_users
    {
      data: @users.map { |user| serialise_user(user) }
    }.to_json
  end

  def create_user(json)
    attrs = JSON.parse(json).fetch("data").fetch("attributes")
    @users << User.new(
      "1",
      attrs.fetch("username"),
      attrs.fetch("email"),
    )
    "1"
  end

  def get_user(id)
    {
      data: serialise_user(find_user(id))
    }.to_json
  end

  def update_user(id, json)
    user = find_user(id)
    attrs = JSON.parse(json).fetch("data").fetch("attributes")
    attrs.each do |attr, value|
      user.send("#{attr}=", value)
    end
  end

  def delete_user(id)
    @users.delete(find_user(id))
  end

  private

  def serialise_user(user)
    {
      type: "users",
      id: user.id,
      attributes: {
        username: user.username,
        email: user.email
      }
    }
  end

  def find_user(id)
    @users.find { |user| user.id == id }
  end
end

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
