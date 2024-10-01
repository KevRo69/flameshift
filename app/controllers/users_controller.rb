class UsersController < ApplicationController
  def show
    @user = current_user

    @availability = Availabilty.new
    start_of_month = Date.today.beginning_of_month
    end_of_month = Date.today.end_of_month

    @availabilities_month = @user.availabilties.where(day: start_of_month..end_of_month).uniq { |t| t.day }.sort_by(&:day)

    start_of_next = Date.today.day < 16 ? Date.today.beginning_of_month + 1.months : Date.today.beginning_of_month + 2.months
    end_of_next = Date.today.day < 16 ? Date.today.end_of_month + 1.months : Date.today.end_of_month + 2.months

    @availabilities_next = @user.availabilties.where(day: (start_of_next)..(end_of_next)).uniq { |t| t.day }.sort_by(&:day)
    @availabilities_next_days = @availabilities_next.map { |date| date.day }

    # @cares_month = @user.cares.where(month: Date.today.month, year: Date.today.year)
    # @cares_next = @user.cares.where(month: Date.today.month + 1, year: Date.today.year)
  end
end
