class RegistrationsController < Devise::RegistrationsController
  # Skip the check that prevents logged-in users from accessing sign up
  skip_before_action :require_no_authentication, only: [:new, :create]
  before_action :configure_sign_up_params, only: [:create]

  def new
    # Ensure that the current user does not affect the form rendering
    @user = User.new
    super
  end

  def create
    # Build a new user without interfering with the current user
    @user = User.new(sign_up_params)

    if @user.save
      flash[:notice] = "Utilisateur créé avec succès."
      redirect_to root_path # Adjust as needed
    else
      render :new
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :first_name, :last_name, :COD_1, :CATE, :CA1E, :CE_INC,
      :EQ_INC, :EQ_SAP, :STG, :validator, :team_id
    ])
  end
end
