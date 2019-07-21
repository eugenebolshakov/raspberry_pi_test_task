require "bundler"
Bundler.setup(:default)
require "sinatra"
require "jsonapi/renderer"

get "/users", provides: "json" do
  JSONAPI.render(data: []).to_json
end
