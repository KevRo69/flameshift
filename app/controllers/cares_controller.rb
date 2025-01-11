class CaresController < ApplicationController
  before_action :find_care, only: [:show, :edit, :update]
  before_action :authorize_user, only: [:new, :create, :edit, :update, :destroy_month, :monthly_cares, :modify_cares]

  def index
    @cares = Care.all
    @roles = ["COD1", "CATE", "CE INC", "EQ INC", "EQ SAP / EQ INC", "STG"]
    @users = User.all.sort_by(&:last_name)
    @month = I18n.t('date.month_names').index(params[:month].capitalize)
    @cares_data = @users.each_with_object({}) do |user, hash|
      next if user.first_name == "/"
      monthly_cares = user.cares.where("EXTRACT(MONTH FROM day) = ?", @month).count
      hash[user.id] = {
        monthly_cares: monthly_cares,
        saturday_cares: user.cares.where("EXTRACT(MONTH FROM day) = ? AND EXTRACT(DOW FROM day) = ?", @month, 6).count,
        sunday_cares: user.cares.where("EXTRACT(MONTH FROM day) = ? AND EXTRACT(DOW FROM day) = ?", @month, 0).count
      }
    end

    # Filter by selected month and year
    if params[:month].present? && params[:year].present?
      month = I18n.t('date.month_names').index(params[:month].capitalize) # Get month as integer
      year = params[:year].to_i
      date = Date.new(year, month, 1)
      @cares = @cares.where('extract(month from day) = ? AND extract(year from day) = ?', month, year)

      start_of_month = date.beginning_of_month
      end_of_month = date.end_of_month
      if start_of_month.wday != 0
        first_sunday = start_of_month.next_occurring(:sunday)
      elsif start_of_month.wday == 0
        first_sunday = start_of_month
      end
      if start_of_month.wday != 6
        first_saturday = start_of_month.next_occurring(:saturday)
      elsif start_of_month.wday == 6
        first_saturday = start_of_month
      end
      if start_of_month.wday != 5
        first_friday = start_of_month.next_occurring(:friday)
      elsif start_of_month.wday == 5
        first_friday = start_of_month
      end
      first_friday = first_saturday if first_friday > first_saturday
      first_friday = first_sunday if first_friday > first_sunday
      next_friday = first_sunday.next_occurring(:friday)

      @week_size = date.mon == 7 || date.mon == 8 ? 7 : 3

      @cares_week1 = date.mon == 7 || date.mon == 8 ? Care.where(day: (start_of_month)..(start_of_month + 6.days)) : Care.where(day: (first_friday)..(first_sunday))
      @cares_week2 = date.mon == 7 || date.mon == 8 ? Care.where(day: (start_of_month + 7.days)..(start_of_month + 13.days)) : Care.where(day: (next_friday)..(first_sunday + 7.days))
      @cares_week3 = date.mon == 7 || date.mon == 8 ? Care.where(day: (start_of_month + 14.days)..(start_of_month + 20.days)) : Care.where(day: (next_friday + 7.days)..(first_sunday + 14.days))
      @cares_week4 = date.mon == 7 || date.mon == 8 ? Care.where(day: (start_of_month + 21.days)..(start_of_month + 27.days)) : Care.where(day: (next_friday + 14.days)..(first_sunday + 21.days))
      @cares_week5 = start_of_month + 27.days <= end_of_month ? ((date.mon == 7 || date.mon == 8) ? Care.where(day: (start_of_month + 28.days)..(end_of_month)) : Care.where(day: (next_friday + 21.days)..(last_weekend_day_of_month(year, month)))) : []
    end
  end

  def show
  end

  def new
    @last_day_setting = Setting.first.last_day
    @users = User.where(deactivated: false).reject { |user| user.first_name == "/" }.sort_by(&:last_name)
    @availability = Availabilty.new

    @month_next_array = []

    @availabilities_next_hash = {}
    users_with_zero_availabilities = 0
    @users.each do |user|
      availabilities_next_array = []
      availabilities_next_days_array = []
      12.times do |i|
        start_of_next = Date.today.day <= Setting.first.last_day ? Date.today.beginning_of_month + 1.months + i.month : Date.today.beginning_of_month + 2.months + i.month
        end_of_next = Date.today.day <= Setting.first.last_day ? Date.today.end_of_month + 1.months + i.month : Date.today.end_of_month + 2.months + i.month
        month_next = I18n.t('date.month_names')[start_of_next.month]
        @month_next_array << month_next
        availabilities_next = user.availabilties.where(day: (start_of_next)..(end_of_next)).uniq { |t| t.day }.sort_by(&:day)
        availabilities_next_days = availabilities_next.map { |date| date.day }
        availabilities_next_array << availabilities_next
        availabilities_next_days_array << availabilities_next_days
        if i == 0
          if availabilities_next.empty?
            users_with_zero_availabilities += 1
          end
        end
      end
      @availabilities_next_hash[user.id] = { availabilities_next_days_array: availabilities_next_days_array }
    end

    @care = Care.new
    @start_of_next = Date.today.beginning_of_month + 1.months
    @month = I18n.l(@start_of_next, format: '%B')
    @alert_message = users_with_zero_availabilities == 0 ?
                    "Tout le monde a rempli ses disponibilités du mois.\nÊtes-vous sûr de vouloir générer les gardes de #{@month} ?" :
                    users_with_zero_availabilities == 1 ?
                    "Attention, #{users_with_zero_availabilities} utilisateur n'a pas rempli ses disponibilités du mois.\nÊtes-vous sûr de vouloir générer les gardes de #{@month} ?" :
                    "Attention, #{users_with_zero_availabilities} utilisateurs n'ont pas rempli leurs disponibilités du mois.\nÊtes-vous sûr de vouloir générer les gardes de #{@month} ?"
    end_of_next = Date.today.end_of_month + 1.months
    @cares_next = Care.where(day: (@start_of_next)..(end_of_next))
    @cares_missing = @cares_next.reject do |care|
      if care.users.where(first_name: "/").count.zero?
        true
      elsif care.users.where(first_name: "/").count == 1 && care.users.last.first_name == "/"
        true
      elsif care.users.where(first_name: "/").count == 1 && care.users[-2].first_name == "/"
        true
      elsif care.users.where(first_name: "/").count == 2 && care.users.last.first_name == "/" && care.users[-2].first_name == "/"
        true
      else
        false
      end
    end
  end

  def create
    start_of_month = Date.today.beginning_of_month + 1.months
    end_of_month = Date.today.end_of_month + 1.months
    usernil = User.find_by(first_name: "/")
    days = (start_of_month..end_of_month).to_a.select { |day| [5, 6, 0].include?(day.wday) }
    days = (start_of_month..end_of_month).to_a if start_of_month.mon == 7 || start_of_month.mon == 8
    days.each do |day|
      @care = Care.new(day: day)
      user_cod = weight_care(day, get_users_cod(day))
      user_cate = weight_care(day, (get_users_cate(day) - [user_cod]))
      user_ce_inc = weight_care(day, (get_users_ce_inc(day) - [user_cod] - [user_cate]))
      user_eq_inc = weight_care(day, (get_users_eq_inc(day) - [user_cod] - [user_cate] - [user_ce_inc]))
      user_eq_sap = weight_care(day, (get_users_eq_sap(day) - [user_cod] - [user_cate] - [user_ce_inc] - [user_eq_inc]))
      user_stg = weight_care(day, (get_users_stg(day) - [user_cod] - [user_cate] - [user_ce_inc] - [user_eq_inc] - [user_eq_sap]))
      unless get_users_cod(day).empty? || user_cod.nil?
        @care.users << user_cod
      else
        @care.users << usernil
      end
      unless get_users_cate(day).empty? || user_cate.nil?
        @care.users << user_cate
      else
        @care.users << usernil
      end
      unless get_users_ce_inc(day).empty? || user_ce_inc.nil?
        @care.users << user_ce_inc
      else
        @care.users << usernil
      end
      unless get_users_eq_inc(day).empty? || user_eq_inc.nil?
        @care.users << user_eq_inc
      else
        @care.users << usernil
      end
      unless get_users_eq_sap(day).empty? || user_eq_sap.nil?
        @care.users << user_eq_sap
      else
        @care.users << usernil
      end
      unless get_users_stg(day).empty? || user_stg.nil?
        @care.users << user_stg
      else
        @care.users << usernil
      end
      @care.save
    end
    redirect_to new_care_path, notice: 'Gardes créées avec succès.'
  end

  def edit
    @users_cod = User.where(COD_1:"1", deactivated: false).sort_by(&:last_name)
    @users_cate = User.where(CATE:"1", deactivated: false).sort_by(&:last_name)
    @users_ca1e = User.where(CA1E:"1", deactivated: false).sort_by(&:last_name)
    @users_others = User.where(STG:"0", deactivated: false).sort_by(&:last_name) - @users_cate - @users_ca1e
    @users_ce_inc = User.where(CE_INC:"1", deactivated: false).sort_by(&:last_name)
    @users_eq_inc = User.where(EQ_INC:"1", deactivated: false).sort_by(&:last_name)
    @users_eq_sap = User.where(EQ_SAP:"1", deactivated: false).sort_by(&:last_name)
    @users_stg = User.where(STG:"1", deactivated: false).sort_by(&:last_name)
  end

  def update
    @care = Care.find(params[:id])
    @care.users.clear
    # Remove user_cares where user_id is blank
    user_cares_params = care_params[:user_cares_attributes].values

    @users_cod = get_users_cod(@care.day)

    user_cares_params.each do |user_care_params|
      if user_care_params[:user_id].blank? && user_care_params[:id].present?
        # If the user_id is blank and an id is present, destroy the user_care
        user_care = @care.user_cares.find_by(id: user_care_params[:id])
        user_care.destroy if user_care
      elsif user_care_params[:user_id].present?
        # If user_id is present, update or create as necessary
        user_care = @care.user_cares.find_or_initialize_by(id: user_care_params[:id])
        user_care.user_id = user_care_params[:user_id]
        user_care.save
      end
    end

    redirect_to new_care_path, notice: 'Garde modifiée avec succès.'
    # rescue ActiveRecord::RecordInvalid => e
    #   flash.now[:error] = e.message
    #   render :edit
  end

  def destroy_month
    start_of_next =  Date.today.beginning_of_month + 1.months
    end_of_next =  Date.today.end_of_month + 1.months
    @cares = Care.where(day: (start_of_next)..(end_of_next))
    @cares.each do |care|
      care.destroy
    end
    redirect_to new_care_path, status: :see_other
  end

  def monthly_cares
    @user = current_user
    @cares = @user.cares
    # Filter by selected month and year
    if params[:month].present? && params[:year].present?
      month = I18n.t('date.month_names').index(params[:month].capitalize) # Get month as integer
      year = params[:year].to_i
      @cares = @cares.where('extract(month from day) = ? AND extract(year from day) = ?', month, year)
    end
  end

  def modify_cares
    @user = current_user
    @cares = Care.all
    # Filter by selected month and year
    if params[:month].present? && params[:year].present?
      month = I18n.t('date.month_names').index(params[:month].capitalize) # Get month as integer
      year = params[:year].to_i
      @cares = @cares.where('extract(month from day) = ? AND extract(year from day) = ?', month, year)
    end
  end

  private

  def last_weekend_day_of_month(year, month)
    last_day = Date.new(year, month, -1)
    while ![5, 6, 7].include?(last_day.cwday)
      last_day -= 1
    end
    last_day
  end

  def care_params
    params.require(:care).permit(
      :day,
      user_cares_attributes: [:id, :user_id, :care_id, :_destroy] # Allow :id and :_destroy for editing/removing
    )
  end

  def find_care
    @care = Care.find(params[:id])
  end

  def get_users_cod(day)
    User.where(COD_1:"1").select do |user|
      user.availabilties.map { |a| a.day.strftime('%d-%m-%Y') }.include?(day.strftime('%d-%m-%Y'))
    end
  end

  def get_users_cate(day)
    User.where(CATE:"1").select do |user|
      user.availabilties.map { |a| a.day.strftime('%d-%m-%Y') }.include?(day.strftime('%d-%m-%Y'))
    end
  end

  def get_users_ce_inc(day)
    User.where(CE_INC:"1").select do |user|
      user.availabilties.map { |a| a.day.strftime('%d-%m-%Y') }.include?(day.strftime('%d-%m-%Y'))
    end
  end

  def get_users_eq_inc(day)
    User.where(EQ_INC:"1").select do |user|
      user.availabilties.map { |a| a.day.strftime('%d-%m-%Y') }.include?(day.strftime('%d-%m-%Y'))
    end
  end

  def get_users_eq_sap(day)
    User.where(EQ_SAP:"1").select do |user|
      user.availabilties.map { |a| a.day.strftime('%d-%m-%Y') }.include?(day.strftime('%d-%m-%Y'))
    end
  end

  def get_users_stg(day)
    User.where(STG:"1").select do |user|
      user.availabilties.map { |a| a.day.strftime('%d-%m-%Y') }.include?(day.strftime('%d-%m-%Y'))
    end
  end

  def weight_care(day, users)
    if users.empty?
      return nil
    else
      users_cares = {
        users: [],
        cares: [],
        sat: [],
        sun: []
      }
      # Get cares for each user and shuffle for more randomness
      users.shuffle.each do |user|
        users_cares[:users] << user
        users_cares[:cares] << user.cares.where("EXTRACT(MONTH FROM day) = ?", day.month).count
        users_cares[:sat] << user.cares.where("EXTRACT(MONTH FROM day) = ? AND EXTRACT(DOW FROM day) = ?", day.month, 6).count
        users_cares[:sun] << user.cares.where("EXTRACT(MONTH FROM day) = ? AND EXTRACT(DOW FROM day) = ?", day.month, 0).count
      end
      # Prority to weekends (Saturday)
      index_min_sat = users_cares[:sat].each_with_index.min[1]
      return users_cares[:users][index_min_sat] if day.saturday?

      # Prority to weekends (Sunday)
      index_min_sun = users_cares[:sun].each_with_index.min[1]
      return users_cares[:users][index_min_sun] if day.sunday?

      # Prority to users with less cares
      index_min = users_cares[:cares].each_with_index.min[1]
      return users_cares[:users][index_min]
    end
  end

  def authorize_user
    unless current_user&.validator?
      redirect_to root_path, alert: "Vous n'êtes pas autorisé à accéder à cette page."
    end
  end
end
