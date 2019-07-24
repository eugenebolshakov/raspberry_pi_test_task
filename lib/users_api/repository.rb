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
      User[id]
    end

    def create(attrs)
      User.new(attrs).then do |user|
        user.save
        user
      end
    end

    def update(id, attrs)
      get(id).then do |user|
        user.update(attrs)
        user
      end
    end

    def delete(id)
      get(id).delete
    end
  end
end
