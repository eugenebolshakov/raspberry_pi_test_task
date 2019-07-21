require "bundler"
Bundler.setup(:default)
require "sinatra"
require "json"

get "/users", provides: "json" do
  { data: [] }.to_json
end
