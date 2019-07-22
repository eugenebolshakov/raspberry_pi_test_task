class JSONAPI
  require "./lib/jsonapi/serialiser"

  def initialize(users = [])
    @users = []
  end

  def list_users
    Serialiser.serialise_users(@users).to_json
  end

  def create_user(json)
    attrs = Serialiser.deserialise_user(json)
    @users << User.new(
      "1",
      attrs.fetch("username"),
      attrs.fetch("email"),
    )
    "1"
  end

  def get_user(id)
    Serialiser.serialise_user(find_user(id)).to_json
  end

  def update_user(id, json)
    user = find_user(id)
    attrs = Serialiser.deserialise_user(json)
    attrs.each do |attr, value|
      user.send("#{attr}=", value)
    end
  end

  def delete_user(id)
    @users.delete(find_user(id))
  end

  private

  def find_user(id)
    @users.find { |user| user.id == id }
  end
end

