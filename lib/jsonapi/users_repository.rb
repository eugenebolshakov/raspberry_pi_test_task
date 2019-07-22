class JSONAPI
  class UsersRepository
    def initialize
      @users = []
    end

    def all
      @users.dup
    end

    def get(id)
      @users.find { |user| user.id == id }
    end

    def create(attrs)
      (@users << User.new(
        "1",
        attrs.fetch("username"),
        attrs.fetch("email")
      )).last
    end

    def update(id, attrs)
      get(id).then do |user|
        attrs.each do |attr, value|
          user.send("#{attr}=", value)
        end
      end
    end

    def delete(id)
      @users.delete(get(id))
    end
  end
end
