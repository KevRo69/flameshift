class UsersController < ApplicationController
  def show
    @user = current_user
    @availabilities_month = @user.availabilties.where(month: Date.today.month, year: Date.today.year)
    @cares_month = @user.cares.where(month: Date.today.month, year: Date.today.year)
    @availabilities_next = @user.availabilties.where(month: Date.today.month + 1, year: Date.today.year)
    @cares_next = @user.cares.where(month: Date.today.month + 1, year: Date.today.year)
  end
end
