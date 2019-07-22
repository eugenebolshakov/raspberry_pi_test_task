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
      end

      private

      def serialise_user_resource(user)
        {
          type: "users",
          id: user.id,
          attributes: {
            username: user.username,
            email: user.email
          }
        }
      end
    end
  end
end
