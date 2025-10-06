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
        friday_cares: user.cares.where("EXTRACT(MONTH FROM day) = ? AND EXTRACT(DOW FROM day) = ?", @month, 5).count,
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

      @cares_week1 = date.mon == 7 || date.mon == 8 ? Care.where(day: (start_of_month)..(start_of_month + 6.days)).sort_by(&:day) : Care.where(day: (first_friday)..(first_sunday)).sort_by(&:day)
      @cares_week2 = date.mon == 7 || date.mon == 8 ? Care.where(day: (start_of_month + 7.days)..(start_of_month + 13.days)).sort_by(&:day) : Care.where(day: (next_friday)..(first_sunday + 7.days)).sort_by(&:day)
      @cares_week3 = date.mon == 7 || date.mon == 8 ? Care.where(day: (start_of_month + 14.days)..(start_of_month + 20.days)).sort_by(&:day) : Care.where(day: (next_friday + 7.days)..(first_sunday + 14.days)).sort_by(&:day)
      @cares_week4 = date.mon == 7 || date.mon == 8 ? Care.where(day: (start_of_month + 21.days)..(start_of_month + 27.days)).sort_by(&:day) : Care.where(day: (next_friday + 14.days)..(first_sunday + 21.days)).sort_by(&:day)
      @cares_week5 = start_of_month + 27.days <= end_of_month ? ((date.mon == 7 || date.mon == 8) ? Care.where(day: (start_of_month + 28.days)..(end_of_month)).sort_by(&:day) : Care.where(day: (next_friday + 21.days)..(last_weekend_day_of_month(year, month))).sort_by(&:day)) : []
    end
  end

  def show
  end

  def new
    today = Date.today
    last_day_setting = Setting.first.last_day
    days_waiting_setting = Setting.first.days_waiting
    @last_day_availabilities_setting = last_day_setting + days_waiting_setting
    last_day_availabilities = Date.new(today.year, today.month, last_day_setting) + days_waiting_setting.days
    @users = User.where(deactivated: false).reject { |user| user.first_name == "/" }.sort_by(&:last_name)
    @availability = Availabilty.new

    @month_next_array = []

    @availabilities_next_hash = {}
    users_with_zero_availabilities = 0
    @users.each do |user|
      availabilities_next_array = []
      availabilities_next_days_array = []
      12.times do |i|
        start_of_next = today <= last_day_availabilities ? today.beginning_of_month + 1.months + i.month : today.beginning_of_month + 2.months + i.month
        end_of_next = today <= last_day_availabilities ? (today.at_beginning_of_month + 2.months + i.month).end_of_month : (today.at_beginning_of_month + 3.months + i.month).end_of_month
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
    @start_of_next = today.beginning_of_month + 1.months
    @month = I18n.l(@start_of_next, format: '%B')
    @alert_message = users_with_zero_availabilities == 0 ?
                    "Tout le monde a rempli ses disponibilités du mois.\nÊtes-vous sûr de vouloir générer les gardes de #{@month} ?" :
                    users_with_zero_availabilities == 1 ?
                    "Attention, #{users_with_zero_availabilities} utilisateur n'a pas rempli ses disponibilités du mois.\nÊtes-vous sûr de vouloir générer les gardes de #{@month} ?" :
                    "Attention, #{users_with_zero_availabilities} utilisateurs n'ont pas rempli leurs disponibilités du mois.\nÊtes-vous sûr de vouloir générer les gardes de #{@month} ?"
    end_of_next = (today.at_beginning_of_month + 2.months - 1.day)
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
    end_of_month = (Date.today.at_beginning_of_month + 2.months - 1.day)
    if Care.where("EXTRACT(MONTH FROM day) = ?", start_of_month.month).count == 0
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
        @care.user_id = User.where(email:"nil").first.id
        @care.save
      end
      users = User.where(deactivated: false, unavailable: false).reject { |user| user.email == "nil" }
      Availabilties::CreateMonthlyAvailabilities.new(users).execute
      redirect_to new_care_path, notice: 'Gardes créées avec succès.'
    else
      redirect_to new_care_path, alert: 'Les gardes du mois ont déjà été créées.'
    end
  end

  def edit
    care = Care.find(params[:id])
    @usernil_id = User.where(email:'nil').first.id
    user_cod1 = [care.users[0]]
    user_cate = [care.users[1]]
    user_ce_inc = [care.users[2]]
    user_eq_inc = [care.users[3]]
    user_eq_sap = [care.users[4]]
    user_stg = [care.users[5]]
    @users = User.where(deactivated: false, unavailable: false).sort_by(&:last_name)
    @user_sog = User.where(id: Care.find(params[:id]).user_id).first
    @users_cod = (User.where(COD_1:"1", deactivated: false, unavailable: false).sort_by(&:last_name) + user_cod1).uniq
    @users_cate = (User.where(CATE:"1", deactivated: false, unavailable: false).sort_by(&:last_name) + user_cate).uniq
    @users_ca1e = (User.where(CA1E:"1", deactivated: false, unavailable: false).sort_by(&:last_name)).uniq
    @users_others = (User.where(STG:"0", deactivated: false, unavailable: false).sort_by(&:last_name) - @users_cate - @users_ca1e).uniq
    @users_ce_inc = (User.where(CE_INC:"1", deactivated: false, unavailable: false).sort_by(&:last_name) + user_ce_inc).uniq
    @users_eq_inc = (User.where(EQ_INC:"1", deactivated: false, unavailable: false).sort_by(&:last_name) + user_eq_inc).uniq
    @users_eq_sap = (User.where(EQ_SAP:"1", deactivated: false, unavailable: false).sort_by(&:last_name) + user_eq_sap).uniq
    @users_stg = (User.where(STG:"1", deactivated: false, unavailable: false).sort_by(&:last_name) + user_stg).uniq
  end

  def update
    @care = Care.find(params[:id])
    @care.users.clear
    # Remove user_cares where user_id is blank
    user_cares_params = care_params[:user_cares_attributes].values

    @users_cod = get_users_cod(@care.day)

    user_cares_params.each_with_index do |user_care_params, index|
      if index == 6
        @care.user_id = user_care_params[:user_id]
        @care.save
      elsif user_care_params[:user_id].blank? && user_care_params[:id].present?
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

    redirect_to modify_cares_path(month: I18n.l(Date.today, format: '%B').downcase, year: Date.today.strftime('%Y')), notice: 'Garde modifiée avec succès.'
    # rescue ActiveRecord::RecordInvalid => e
    #   flash.now[:error] = e.message
    #   render :edit
  end

  def destroy_month
    start_of_next =  Date.today.beginning_of_month + 1.months
    end_of_next =  (Date.today.at_beginning_of_month + 2.months - 1.day)
    unless Care.where("EXTRACT(MONTH FROM day) = ?", start_of_next.month).count == 0
      @cares = Care.where(day: (start_of_next)..(end_of_next))
      @cares.each do |care|
        care.destroy
      end
      redirect_to new_care_path, status: :see_other
    else
      redirect_to new_care_path, alert: 'Les gardes du mois ont déjà été supprimées.'
    end
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
    @cares = Care.order(:day)
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
        cares: []
      }

      users.shuffle.each do |user|
        users_cares[:users] << user
        users_cares[:cares] << user.cares.where("EXTRACT(MONTH FROM day) = ?", day.month).count
      end

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
