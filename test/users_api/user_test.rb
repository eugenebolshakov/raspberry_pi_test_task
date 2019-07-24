require "./test/test_helper"
require "./lib/users_api/user"

module UsersAPI
  describe User do
    it "hashes password" do
      user = User.new(password: "pa$$w0rd")
      assert user.password_hash

      user = User.new(password_hash: user.password_hash)
      refute user.password == "password"
      assert user.password == "pa$$w0rd"
    end

    it "handles missing password" do
      refute User.new.password
      refute User.new.password_hash
      refute User.new(password: "").password_hash
    end

    it "validates presense of all attributes" do
      user = User.new
      refute user.valid?
      assert_equal ["is not present"], user.errors[:username]
      assert_equal ["is not present"], user.errors[:email]
      assert_equal ["is not present"], user.errors[:password]
    end

    it "validates uniqueness of username and email" do
      User.new(
        username: "username", 
        email: "email@example.com", 
        password: "pa$$w0rd"
      ).save
      user = User.new(
        username: "username", 
        email: "email@example.com", 
        password: "pa$$w0rd"
      )
      refute user.valid?
      assert_equal ["is already taken"], user.errors[:username]
      assert_equal ["is already taken"], user.errors[:email]
    end
  end
end
