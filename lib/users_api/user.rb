require "bcrypt"

module UsersAPI
  class User < Sequel::Model
    def password
      @password ||= BCrypt::Password.new(password_hash)
    end

    def password=(value)
      @password = BCrypt::Password.create(value)
      self.password_hash = @password
    end
  end
end
