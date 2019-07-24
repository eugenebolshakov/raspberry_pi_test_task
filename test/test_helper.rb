require "minitest/autorun"
require "bundler"
Bundler.setup(:default, :test)

ENV["RACK_ENV"] = "test"
ENV["DB_URL"] = "sqlite:/file::memory:?cache=shared"
ENV["API_KEY"] = API_KEY = "TEST-API-KEY"

require "./lib/users_api/repository"
UsersAPI::Repository.setup(ENV["DB_URL"], force: true)
