class UserManeuversController < ApplicationController
  def index
    @users_active = User.where(deactivated: false).sort_by(&:last_name)
    @resource_name = :user
    @year = Date.today.year
  end

  def update
    user = User.find(params[:id])
    user_maneuver = user.user_maneuvers.where(user_id: user.id, year: params[:user][:year]).empty? ?
                    UserManeuver.create(user_id: user.id, year: params[:user][:year], number: params[:user][:user_maneuver]) :
                    user.user_maneuvers.where(user: user, year: params[:user][:year]).first

    params[:user][:user_maneuver] = params[:user][:user_maneuver].to_i < 0 ? 0 : params[:user][:user_maneuver]

    if user_maneuver.update(number: params[:user][:user_maneuver])
      redirect_to user_maneuvers_path, notice: "Mise à jour des manœuvres effectuée."
    else
      flash[:error] = "Échec de la mise à jour des manœuvres."
      render :edit
    end
  end

  private

  def user_maneuver_params
    params.require(:user_maneuver).permit(:year, :number, :user_id)
  end
end
