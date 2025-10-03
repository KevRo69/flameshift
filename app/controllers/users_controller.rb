class UsersController < ApplicationController
  before_action :authorize_user, only: [:index, :update]

  def index
    @users_active = User.where(deactivated: false).sort_by(&:last_name)
    @users_inactive = User.where(deactivated: true).sort_by(&:last_name)
    @resource_name = :user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      Availabilties::DeleteUserAvailabilities.new(@user).execute if user_params[:unavailable] == '1'
      redirect_to users_path, notice: 'Informations mises à jour.'
    else
      flash[:alert] = 'Échec de mise à jour des informations.'
      render :index
    end
  end

  def deactivate
    @user = User.find(params[:id])
    @user.update(deactivated: true)
    redirect_to users_path, notice: "L'utilisateur #{@user.first_name} #{@user.last_name} a été désactivé."
  end

  def reactivate
    @user = User.find(params[:id])
    @user.update(deactivated: false)
    redirect_to users_path, notice: "L'utilisateur #{@user.first_name} #{@user.last_name} a été réactivé."
  end

  def reset_password
    @user = User.find(params[:id])
    password = SecureRandom.hex(6)
    @user.update(password: password, password_confirmation: password)
    redirect_to users_path, notice: "Le mot de passe de #{@user.first_name} #{@user.last_name} a été réinitialisé (nouveau mot de passe: #{password})"
  end

  def show
    @last_day_setting = Setting.first.last_day
    @rules = Setting.first.rules
    @user = current_user
    @care = Care.new

    @availability = Availabilty.new
    start_of_month = Date.today.beginning_of_month
    end_of_month = Date.today.end_of_month

    @month_next_array = []
    @availabilities_next_array = []
    @availabilities_next_days_array = []

    12.times do |i|
      start_of_next = Date.today.day <= @last_day_setting ? Date.today.beginning_of_month + 1.months + i.month : Date.today.beginning_of_month + 2.months + i.month
      end_of_next = Date.today.day <= @last_day_setting ? (Date.today.at_beginning_of_month + 2.months + i.month).end_of_month : (Date.today.at_beginning_of_month + 3.months + i.month).end_of_month
      month_next = I18n.t('date.month_names')[start_of_next.month]
      @month_next_array << month_next
      availabilities_next = @user.availabilties.where(day: (start_of_next)..(end_of_next)).uniq { |t| t.day }.sort_by(&:day)
      availabilities_next_days = availabilities_next.map { |date| date.day }
      @availabilities_next_array << availabilities_next
      @availabilities_next_days_array << availabilities_next_days
    end

    start_of_next_care = Date.today.beginning_of_month + 1.months
    end_of_next_care = (Date.today.at_beginning_of_month + 2.months - 1.day)

    @cares_month = @user.cares.where(day: (start_of_month)..(end_of_month)).uniq { |t| t.day }.sort_by(&:day).map { |date| date.day }
    @cares_next = @user.cares.where(day: (start_of_next_care)..(end_of_next_care)).uniq { |t| t.day }.sort_by(&:day).map { |date| date.day }

    @users_cod = get_number_user_available_per_day("COD_1")
    @users_cate = get_number_user_available_per_day("CATE")
    @users_ca1e = get_number_user_available_per_day("CA1E")
    @users_ce_inc = get_number_user_available_per_day("CE_INC")
    @users_eq_inc = get_number_user_available_per_day("EQ_INC")
    @users_eq_sap = get_number_user_available_per_day("EQ_SAP")
    @users_stg = get_number_user_available_per_day("STG")
  end

  def check_username
    existing_usernames = User.where("email ~* ?", "^#{params[:username]}[0-9]*$")
    username_exists = existing_usernames.length > 0

    max_suffix = existing_usernames
                   .pluck(Arel.sql("COALESCE(NULLIF(REGEXP_REPLACE(email, '^#{params[:username]}', ''), ''), '0')::int"))
                   .max || 0

    render json: { exists: username_exists, highest_username: max_suffix}
  end

  private

  def user_params
    params.require(:user).permit(:email, :COD_1, :CATE, :CE_INC, :EQ_INC, :EQ_SAP, :CA1E, :STG, :validator, :password, :password_confirmation, :current_password, :unavailable)
  end

  def authorize_user
    unless current_user&.validator?
      redirect_to root_path, alert: "Vous n'êtes pas autorisé à accéder à cette page."
    end
  end

  def get_number_user_available_per_day(type)
    # create a hash with the number of user available per day for each day
    users_cod = {}
    User.where("#{type}": "1").each do |user|
      user.availabilties.each do |availability|
        if availability.day >= Date.today
          users_cod["d#{availability.day.strftime('%Y_%m_%d')}"] = 0 unless users_cod["d#{availability.day.strftime('%Y_%m_%d')}"]
          users_cod["d#{availability.day.strftime('%Y_%m_%d')}"] += 1
        end
      end
    end
    users_cod.sort.to_h
  end
end
