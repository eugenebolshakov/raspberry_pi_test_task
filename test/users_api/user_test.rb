require "./test/test_helper"
require "./lib/users_api/user"

module UsersAPI
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
