module Availabilties
  class CreateFakeAvailabilties
    def initialize(users, start_date)
      @users = users
      @start_date = start_date.to_s
      @end_date = start_date.end_of_month.to_s
    end

    def execute
      @users.each do |user|
        create_availabilties(user)
        remove_duplicates(user)
      end
    end

    private

    def create_availabilties(user)
      rand(70).times do
        random_date = Faker::Date.between(from: @start_date, to: @end_date)
        user.availabilties.create!(day: random_date)
      end
    end

    def remove_duplicates(user)
      user.availabilties.group(:day).having('COUNT(*) > 1').pluck(:day).each do |day|
        duplicates = user.availabilties.where(day: day).order(:id)
        duplicates.offset(1).delete_all
      end
    end
  end
end
