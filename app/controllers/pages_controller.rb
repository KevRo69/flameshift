class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: :home

  def home
    @warning = Setting.first.warning
    start_of_month = Date.today.beginning_of_month
    end_of_month = Date.today.end_of_month
    days = (start_of_month..end_of_month).to_a
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
    @year = Date.today.year
    month = Date.today.month

    @week_size = start_of_month.mon == 7 || start_of_month.mon == 8 ? 7 : 3

    @cares_week1 = start_of_month.mon == 7 || start_of_month.mon == 8 ? Care.where(day: (start_of_month)..(start_of_month + 6.days)) : Care.where(day: (first_friday)..(first_sunday))
    @cares_week2 = start_of_month.mon == 7 || start_of_month.mon == 8 ? Care.where(day: (start_of_month + 7.days)..(start_of_month + 13.days)) : Care.where(day: (next_friday)..(first_sunday + 7.days))
    @cares_week3 = start_of_month.mon == 7 || start_of_month.mon == 8 ? Care.where(day: (start_of_month + 14.days)..(start_of_month + 20.days)) : Care.where(day: (next_friday + 7.days)..(first_sunday + 14.days))
    @cares_week4 = start_of_month.mon == 7 || start_of_month.mon == 8 ? Care.where(day: (start_of_month + 21.days)..(start_of_month + 27.days)) : Care.where(day: (next_friday + 14.days)..(first_sunday + 21.days))
    @cares_week5 = start_of_month + 27.days <= end_of_month ? (start_of_month.mon == 7 || start_of_month.mon == 8 ? Care.where(day: (start_of_month + 28.days)..(end_of_month)) : Care.where(day: (next_friday + 21.days)..(last_weekend_day_of_month(@year, month)))) : []

    @current_week = week_of_month(Date.today, @cares_week5)
    params[:week] = @current_week.to_s if params[:week].nil?
    @users = User.all.sort_by(&:last_name)

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
    @maneuvers = @users.each_with_object({}) do |user, hash|
      next if user.first_name == "/"
      hash[user.id] = {
        yearly_maneuvers: user.user_maneuvers.where("year = ?", @year).first.nil? ? 0 : user.user_maneuvers.where("year = ?", @year).first.number
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

  def infos
    @infos = Setting.first.infos
  end

  private

  def week_of_month(date, cares_week5, week_start_day: :monday)
    # Determine the first week start aligned with the chosen day
    first_week_start = date.beginning_of_month.beginning_of_week(week_start_day)

    # Calculate the week number
    week_number = ((date - first_week_start).to_i / 7) + 1

    # Cap the result at 5
    if cares_week5.empty?
      week_number > 4 ? 4 : week_number
    else
      week_number > 5 ? 5 : week_number
    end
  end

  def last_weekend_day_of_month(year, month)
    last_day = Date.new(year, month, -1)
    while ![5, 6, 7].include?(last_day.cwday)
      last_day -= 1
    end
    last_day
  end
end
