class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: :home

  def home
    start_of_month = Date.today.beginning_of_month
    end_of_month = Date.today.end_of_month
    days = (start_of_month..end_of_month).to_a
    @current_week = (Date.today.beginning_of_month.cweek == Date.today.cweek) ? 1 : ((Date.today.beginning_of_week(:monday).day - 1) / 7) + 1
    params[:week] = @current_week.to_s if params[:week].nil?
    @cares = Care.where(day: days)
    @roles = ["COD1", "CATE", "CE INC", "EQ INC", "EQ SAP / EQ INC", "STG"]
    if start_of_month.wday != 0
      first_sunday = start_of_month.next_occurring(:sunday)
    elsif start_of_month.wday == 0
      first_sunday = start_of_month
    end
    if start_of_month.wday != 5
      first_friday = start_of_month.next_occurring(:friday)
    elsif start_of_month.wday == 5
      first_friday = start_of_month
    end

    first_friday = first_sunday if first_friday > first_sunday
    next_friday = first_sunday.next_occurring(:friday)

    @cares_week1 = Care.where(day: (first_friday)..(first_sunday))
    @cares_week2 = Care.where(day: (next_friday)..(first_sunday + 7.days))
    @cares_week3 = Care.where(day: (next_friday + 7.days)..(first_sunday + 14.days))
    @cares_week4 = Care.where(day: (next_friday + 14.days)..(first_sunday + 21.days))
    @cares_week5 = start_of_month + 28.days < end_of_month ? Care.where(day: (next_friday + 21.days)..(first_sunday + 28.days)) : []
    @users = User.all
    @year = Date.today.year
    @weeks = ["Semaine 1", "Semaine 2", "Semaine 3", "Semaine 4"]
    @weeks << "Semaine 5" if !@cares_week5.empty?
    @cares_data = @users.each_with_object({}) do |user, hash|
      next if user.first_name == "/"
      yearly_cares = user.cares.where("EXTRACT(YEAR FROM day) = ?", @year).count
      hash[user.id] = {
        yearly_cares: yearly_cares,
        saturday_cares: user.cares.where("EXTRACT(YEAR FROM day) = ? AND EXTRACT(DOW FROM day) = ?", @year, 6).count,
        sunday_cares: user.cares.where("EXTRACT(YEAR FROM day) = ? AND EXTRACT(DOW FROM day) = ?", @year, 0).count
      }
    end
    if params[:week].present?
      case params[:week]
      when "1"
        @cares = @cares_week1
      when "2"
        @cares = @cares_week2
      when "3"
        @cares = @cares_week3
      when "4"
        @cares = @cares_week4
      when "5"
        @cares = @cares_week5
      end
    end
  end
end
