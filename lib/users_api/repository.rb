require "sequel"

module UsersAPI
  class Repository
    def self.setup(db_url, force: false)
      db = Sequel.connect(db_url)
      method = force ? :create_table! : :create_table?
      db.public_send(method, :users) do
        primary_key :id
        String :username, unique: true, null: false
        String :email, unique: true, null: false
        String :password_hash, null: false
      end
    end

    def initialize(db_url)
      Sequel.connect(db_url)
      require "./lib/users_api/user"
    end

    def all
      User.all
    end

    def get(id)
      User[id] or raise NotFound
    end

    def create(attrs)
      User.new.then do |user|
        user.set_fields(attrs, %w(username email password), missing: :skip)
        user.save
        user
      end
    rescue Sequel::ValidationFailed => e
      raise InvalidRequest.new(e)
    end

    def update(id, attrs)
      get(id).then do |user|
        user.set_fields(attrs, %w(username email password), missing: :skip)
        user.save
        user
      end
    end

    def delete(id)
      get(id).delete
    end
  end
end
