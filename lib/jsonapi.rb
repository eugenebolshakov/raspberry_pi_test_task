class JSONAPI
  require "./lib/jsonapi/serialiser"
  require "./lib/jsonapi/users_repository"

  def self.setup(db_uri:)
    UsersRepository.setup(db_uri)
  end

  def initialize(db_uri:)
    @users = UsersRepository.new(db_uri)
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
end
