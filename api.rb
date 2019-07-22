require "bundler"
Bundler.setup(:default)
require "sinatra"
require "jsonapi/renderer"

get "/users", provides: "json" do
  JSONAPI.render(data: []).to_json
end

post "/users", provides: "json" do
  json = JSON.parse(request.body.read)
  attributes = json.fetch("data").fetch("attributes")
  attributes.delete("password")
  location = "/user/1"
  status(201)
  headers("Location" => location)
  body({
    data: {
      type: "users",
      id: 1,
      attributes: attributes,
      links: { self: location }
    }
  }.to_json)
end
