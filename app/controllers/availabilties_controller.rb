class AvailabiltiesController < ApplicationController
  def index
    @availabilities = Availabilty.all
  end

  def new
    @user = current_user
    @availability = Availabilty.new
  end

  def create
    start_of_next = Date.today.day < 16 ? Date.today.beginning_of_month + 1.months : Date.today.beginning_of_month + 2.months
    end_of_next = Date.today.day < 16 ? Date.today.end_of_month + 1.months : Date.today.end_of_month + 2.months
    availabilities_next = current_user.availabilties.where(day: (start_of_next)..(end_of_next))
    avaibilities_next_days = availabilities_next.map { |date| date.day.strftime('%Y-%m-%d') }
    availabilities = availability_params[:day].split(", ")
    days_to_destroy = avaibilities_next_days - availabilities
    days_to_destroy.each do |day|
      Availabilty.find_by(day: day, user:current_user).destroy
    end
    availabilities.each do |day|
      if availabilities_next.select { |t| t.day.strftime('%Y-%m-%d') == day }.empty?
        availability = Availabilty.new(day: day, user: current_user)
        availability.save
      end
    end
    redirect_to user_path(current_user)
  end

  def edit
    @user = current_user
    @availability = Availabilty.new

    start_of_next = Date.today.day < 16 ? Date.today.beginning_of_month + 1.months : Date.today.beginning_of_month + 2.months
    end_of_next = Date.today.day < 16 ? Date.today.end_of_month + 1.months : Date.today.end_of_month + 2.months

    @availabilities_next = @user.availabilties.where(day: (start_of_next)..(end_of_next)).uniq { |t| t.day }.sort_by(&:day)
    @availabilities_next_days = @availabilities_next.map { |date| date.day }
  end

  private

  def availability_params
    params.require(:availabilty).permit(:day, :user_id)
  end
end
