require "bcrypt"

module UsersAPI
  class User < Sequel::Model
    plugin :validation_helpers

    def validate
      super
      validates_presence [:username, :email, :password]
      validates_unique :username
      validates_unique :email
    end

    def password
      @password ||= password_hash && BCrypt::Password.new(password_hash)
    end

    def password=(value)
      if value.empty?
        self.password_hash == nil
      else
        @password = BCrypt::Password.create(value)
        self.password_hash = @password
      end
    end
  end
end
