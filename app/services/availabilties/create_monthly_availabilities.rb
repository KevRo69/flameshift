module Availabilties
  class CreateMonthlyAvailabilities
    def initialize(users)
      @users = users
    end

    def execute
      start_date = Date.today.beginning_of_month >> 13
      end_date = start_date.end_of_month
      create_availabilties(start_date, end_date)
    end

    private

    def create_availabilties(start_date, end_date)
      @users.each do |user|
        (start_date..end_date).each do |date|
          user.availabilties.find_or_create_by(day: date)
        end
      end
    end
  end
end
