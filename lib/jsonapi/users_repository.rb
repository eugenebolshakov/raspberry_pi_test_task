require "sequel"

class JSONAPI
  class UsersRepository
    def self.setup(db_uri)
      db = Sequel.connect(db_uri)
      db.create_table?(:users) do
        primary_key :id
        String :username, unique: true, null: false
        String :email, unique: true, null: false
        String :password_hash, null: false
      end
    end

    def initialize(db_uri)
      Sequel.connect(db_uri)
      require "./lib/jsonapi/user"
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
