ENV["RACK_ENV"] = "test"

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
    data = JSON.parse(json).fetch("data")
    @users << User.new(
      "1",
      data.fetch("attributes").fetch("username"),
      data.fetch("attributes").fetch("email"),
    )
    "1"
  end

  def get_user(id)
    {
      data: serialise_user(find_user(id))
    }.to_json
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
