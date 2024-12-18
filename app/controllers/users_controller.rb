class UsersController < ApplicationController
  before_action :authorize_user, only: [:index, :update]

  def index
    @users = User.all.sort_by(&:first_name)
    @resource_name = :user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path, notice: 'Informations mises à jours.'
    else
      flash[:alert] = 'Failed to update user information.'
      render :index
    end
  end

  def show
    @user = current_user
    @care = Care.new

    @availability = Availabilty.new
    start_of_month = Date.today.beginning_of_month
    end_of_month = Date.today.end_of_month

    @availabilities_month = @user.availabilties.where(day: start_of_month..end_of_month).uniq { |t| t.day }.sort_by(&:day)

    start_of_next = Date.today.day < 16 ? Date.today.beginning_of_month + 1.months : Date.today.beginning_of_month + 2.months
    end_of_next = Date.today.day < 16 ? Date.today.end_of_month + 1.months : Date.today.end_of_month + 2.months

    start_of_next2 = Date.today.day < 16 ? Date.today.beginning_of_month + 2.months : Date.today.beginning_of_month + 3.months
    end_of_next2 = Date.today.day < 16 ? Date.today.end_of_month + 2.months : Date.today.end_of_month + 3.months

    start_of_next3 = Date.today.day < 16 ? Date.today.beginning_of_month + 3.months : Date.today.beginning_of_month + 4.months
    end_of_next3 = Date.today.day < 16 ? Date.today.end_of_month + 3.months : Date.today.end_of_month + 4.months


    start_of_next_care = Date.today.beginning_of_month + 1.months
    end_of_next_care = Date.today.end_of_month + 1.months

    @month_next = I18n.t('date.month_names')[start_of_next.month]
    @month_next2 = I18n.t('date.month_names')[start_of_next2.month]
    @month_next3 = I18n.t('date.month_names')[start_of_next3.month]

    @availabilities_next = @user.availabilties.where(day: (start_of_next)..(end_of_next)).uniq { |t| t.day }.sort_by(&:day)
    @availabilities_next_days = @availabilities_next.map { |date| date.day }

    @availabilities_next2 = @user.availabilties.where(day: (start_of_next2)..(end_of_next2)).uniq { |t| t.day }.sort_by(&:day)
    @availabilities_next_days2 = @availabilities_next2.map { |date| date.day }

    @availabilities_next3 = @user.availabilties.where(day: (start_of_next3)..(end_of_next3)).uniq { |t| t.day }.sort_by(&:day)
    @availabilities_next_days3 = @availabilities_next3.map { |date| date.day }

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

  private

  def user_params
    params.require(:user).permit(:email, :COD_1, :CATE, :CE_INC, :EQ_INC, :EQ_SAP, :CA1E, :STG, :validator, :password, :password_confirmation, :current_password)
  end

  private

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
