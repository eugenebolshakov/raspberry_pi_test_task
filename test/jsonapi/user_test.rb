require "minitest/autorun"
require "bundler"
Bundler.setup(:default, :test)

ENV["DB_URI"] = "sqlite:/file::memory:?cache=shared"

require "./lib/jsonapi"
JSONAPI.setup(db_uri: ENV["DB_URI"])

require "./lib/jsonapi/user"

class JSONAPI
  class UserTest < Minitest::Test
    def test_password_hasing
      user = User.new(password: "pa$$w0rd")
      assert user.password_hash

      user = User.new(password_hash: user.password_hash)
      refute user.password == "password"
      assert user.password == "pa$$w0rd"
    end
  end
end
