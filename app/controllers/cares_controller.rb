class CaresController < ApplicationController
  before_action :find_care, only: [:show, :edit, :update]
  def index
    @cares = Care.all
  end

  def show
  end

  def new
    @care = Care.new
  end

  def create
    @care = Care.new(care_params)
    if @care.save
      redirect_to @care
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @care.update(care_params)
      redirect_to @care
    else
      render 'edit'
    end
  end

  private

  def care_params
    params.require(:care).permit(:day, :month, :year, :user_id)
  end

  def find_care
    @care = Care.find(params[:id])
  end
end
