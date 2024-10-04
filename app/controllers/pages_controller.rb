class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    start_of_month = Date.today.day < 16 ? Date.today.beginning_of_month + 1.months : Date.today.beginning_of_month + 2.months
    end_of_month = Date.today.day < 16 ? Date.today.end_of_month + 1.months : Date.today.end_of_month + 2.months
    days = (start_of_month..end_of_month).to_a
    @cares = Care.where(day: days)
    @users = User.all
    @year = Date.today.year
    @cares_data = @users.each_with_object({}) do |user, hash|
      next if user.first_name == "/"
      yearly_cares = user.cares.where("EXTRACT(YEAR FROM day) = ?", @year).count
      hash[user.id] = {
        yearly_cares: yearly_cares,
      }
    end
  end
end
