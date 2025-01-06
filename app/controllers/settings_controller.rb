class SettingsController < ApplicationController
  def index
    @setting = Setting.first
  end

  def edit
    @setting = Setting.find(params[:id])
  end

  def update
    @setting = Setting.find(params[:id])
    if @setting.update(setting_params)
      redirect_to settings_path, notice: 'Paramètres mis à jour.'
    else
      flash[:alert] = 'Échec de mise à jour des paramètres.'
      render :edit
    end
  end

  private

  def setting_params
    params.require(:setting).permit(:rules, :last_day, :warning)
  end
end
