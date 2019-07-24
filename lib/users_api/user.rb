require "bcrypt"

module UsersAPI
  class User < Sequel::Model
    EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    plugin :validation_helpers

    def validate
      super
      validates_presence [:username, :email, :password]
      validates_unique :username
      validates_unique :email
			unless email.to_s.empty?
				validates_format EMAIL_FORMAT, :email, message: "is not a valid email"
			end
    end

    def password
      @password ||= password_hash && BCrypt::Password.new(password_hash)
    end

    def password=(value)
      if value.nil? || value.strip.empty?
        self.password_hash == nil
      else
        @password = BCrypt::Password.create(value)
        self.password_hash = @password
      end
    end
  end
end
