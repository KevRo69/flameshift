class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: :home

  def home
    # start_of_month = Date.today.day < 16 ? Date.today.beginning_of_month + 1.months : Date.today.beginning_of_month + 2.months
    # end_of_month = Date.today.day < 16 ? Date.today.end_of_month + 1.months : Date.today.end_of_month + 2.months
    start_of_month = Date.today.beginning_of_month
    end_of_month = Date.today.end_of_month
    days = (start_of_month..end_of_month).to_a
    @cares = Care.where(day: days)
    @roles = ["COD1", "CATE", "CE INC", "EQ INC", "EQ SAP / EQ INC", "STG"]
    @cares_week1 = Care.where(day: (start_of_month)..(start_of_month + 6.days))
                        .select { |care| [5, 6, 0].include?(care.day.wday) }
    @cares_week2 = Care.where(day: (start_of_month + 7.days)..(start_of_month + 13.days))
                        .select { |care| [5, 6, 0].include?(care.day.wday) }
    @cares_week3 = Care.where(day: (start_of_month + 14.days)..(start_of_month + 20.days))
                        .select { |care| [5, 6, 0].include?(care.day.wday) }
    @cares_week4 = Care.where(day: (start_of_month + 21.days)..(start_of_month + 27.days))
                        .select { |care| [5, 6, 0].include?(care.day.wday) }
    @cares_week5 = start_of_month + 28.days < end_of_month ? Care.where(day: (start_of_month + 28.days)..(end_of_month))
                                                                  .select { |care| [5, 6, 0].include?(care.day.wday) } : []
    @users = User.all
    @year = Date.today.year
    @cares_data = @users.each_with_object({}) do |user, hash|
      next if user.first_name == "/"
      yearly_cares = user.cares.where("EXTRACT(YEAR FROM day) = ?", @year).count
      hash[user.id] = {
        yearly_cares: yearly_cares,
        saturday_cares: user.cares.where("EXTRACT(YEAR FROM day) = ? AND EXTRACT(DOW FROM day) = ?", @year, 6).count,
        sunday_cares: user.cares.where("EXTRACT(YEAR FROM day) = ? AND EXTRACT(DOW FROM day) = ?", @year, 0).count
      }
    end
  end
end
