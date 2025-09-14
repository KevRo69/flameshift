module Availabilties
  class CreateYearlyAvailabilities
    def initialize(user)
      @user = user
    end

    def execute
      start_date = Date.today.beginning_of_month >> 1
      end_date = (start_date >> 12) - 1.days
      create_availabilties(@user, start_date, end_date)
    end

    private

    def create_availabilties(user, start_date, end_date)
      (start_date..end_date).each do |date|
        user.availabilties.find_or_create_by(day: date)
      end
    end
  end
end
