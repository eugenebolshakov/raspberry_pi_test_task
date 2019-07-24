module UsersAPI
  class JSONAPI
    module Serialiser
      class << self
        def serialise_users(users)
          { data: users.map { |user| serialise_user_resource(user) } }
        end

        def serialise_user(user)
          { data: serialise_user_resource(user) }
        end

        def deserialise_user(json)
          JSON.parse(json).fetch("data").fetch("attributes")
        rescue JSON::ParserError => e
          raise InvalidRequest.new(e)
        end

        def serialise_error(error)
          { errors: [{ title: error.class.name, detail: error.message }] }
        end

        private

        def serialise_user_resource(user)
          {
            type: "users",
            id: user.id.to_s,
            attributes: {
              username: user.username,
              email: user.email
            }
          }
        end
      end
    end
  end
end
