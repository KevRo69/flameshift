class AvailabiltiesController < ApplicationController
  def index
    @availabilities = Availability.all
  end

  def create
    @availability = Availability.new(availability_params)
    @availability.user = current_user
    if @availability.save
      redirect_to users_path(current_user)
    else
      render 'new'
    end
  end

  def destroy
  end

  private

  def availability_params
    params.require(:availability).permit(:day, :month, :year, :user_id)
  end
end
