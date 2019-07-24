module UsersAPI
  require "./lib/users_api/repository"

  class JSONAPI
    require "./lib/users_api/json_api/serialiser"

    def initialize(db_url:)
      @users = Repository.new(db_url)
    end

    def list_users
      Serialiser.serialise_users(@users.all).to_json
    end

    def create_user(json)
      @users.create(Serialiser.deserialise_user(json)).id
    end

    def get_user(id)
      Serialiser.serialise_user(@users.get(id)).to_json
    end

    def update_user(id, json)
      @users.update(id, Serialiser.deserialise_user(json))
    end

    def delete_user(id)
      @users.delete(id)
    end

    def error(error)
      Serialiser.serialise_error(error).to_json
    end
  end
end
