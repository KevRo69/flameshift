class AvailabiltiesController < ApplicationController
  def index
    @availabilities = Availabilty.all
  end

  def new
    @user = current_user
    @availability = Availabilty.new
  end

  def create
    availabilities = availability_params[:day].split(", ")
    availabilities.each do |day|
      @availability = Availabilty.new(day: day, user: current_user)
      @availability.save
    end
    redirect_to user_path(current_user)
  end

  def destroy
  end

  private

  def availability_params
    params.require(:availabilty).permit(:day, :user_id)
  end
end
