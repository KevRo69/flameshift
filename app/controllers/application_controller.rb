class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :COD_1, :CATE, :CE_INC, :EQ_INC, :EQ_SAP, :STG, :validator, :team_id])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :COD_1, :CATE, :CE_INC, :EQ_INC, :EQ_SAP, :STG, :validator, :team_id])
  end
end
