class CaresController < ApplicationController
  before_action :find_care, only: [:show, :edit, :update]
  def index
    @cares = Care.all
    @roles = ["COD1", "CATE", "CE INC", "EQ INC", "EQ SAP / EQ INC", "STG"]
    # Filter by selected month and year
    if params[:month].present? && params[:year].present?
      month = I18n.t('date.month_names').index(params[:month].capitalize) # Get month as integer
      year = params[:year].to_i
      date = Date.new(year, month, 1)
      @cares = @cares.where('extract(month from day) = ? AND extract(year from day) = ?', month, year)
      @cares_week1 = @cares.where(day: (date)..(date + 6.days))
      @cares_week2 = @cares.where(day: (date + 7.days)..(date + 13.days))
      @cares_week3 = @cares.where(day: (date + 14.days)..(date + 20.days))
      @cares_week4 = @cares.where(day: (date + 21.days)..(date + 27.days))
      @cares_week5 = date + 28.days < date.end_of_month ? @cares.where(day: (date + 28.days)..(date.end_of_month)) : []
    end
  end

  def show
  end

  def new
    @care = Care.new
    @start_of_next = Date.today.beginning_of_month + 1.months
    @month = I18n.l(@start_of_next, format: '%B')
    end_of_next = Date.today.end_of_month + 1.months
    @cares_next = Care.where(day: (@start_of_next)..(end_of_next))
    @cares_missing = @cares_next.reject do |care|
      if care.users.where(first_name: "/").count.zero?
        true
      elsif care.users.where(first_name: "/").count == 1 && care.users.last.first_name == "/"
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
    days = (start_of_month..end_of_month).to_a
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
    @users_cod = User.where(COD_1:"1")
    @users_cate = User.where(CATE:"1")
    @users_ce_inc = User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1")
    @users_eq_inc = User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1")
    @users_eq_sap = User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1")
    @users_stg = User.where(STG:"1")
  end

  def update
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
rescue ActiveRecord::RecordInvalid => e
  flash.now[:error] = e.message
  render :edit
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

  private

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
    User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1").select do |user|
      user.availabilties.map { |a| a.day.strftime('%d-%m-%Y') }.include?(day.strftime('%d-%m-%Y'))
    end
  end

  def get_users_eq_inc(day)
    User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1").select do |user|
      user.availabilties.map { |a| a.day.strftime('%d-%m-%Y') }.include?(day.strftime('%d-%m-%Y'))
    end
  end

  def get_users_eq_sap(day)
    User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1").select do |user|
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
end
