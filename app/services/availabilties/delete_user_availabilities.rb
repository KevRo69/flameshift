module Availabilties
  class DeleteUserAvailabilities
    def initialize(user)
      @user = user
    end

    def execute
      @user.availabilties.delete_all
    end
  end
end
