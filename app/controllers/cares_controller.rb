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
    start_of_month = Date.today.day < 16 ? Date.today.beginning_of_month + 1.months : Date.today.beginning_of_month + 2.months
    end_of_month = Date.today.day < 16 ? Date.today.end_of_month + 1.months : Date.today.end_of_month + 2.months
    days = (start_of_month..end_of_month).to_a
    days.each do |day|
      @care = Care.new(day: day)
      user_cod = get_users_cod(day).sample
      user_cate = (get_users_cate(day) - [user_cod]).sample
      user_ce_inc = (get_users_ce_inc(day) - [user_cod] - [user_cate]).sample
      user_eq_inc = (get_users_eq_inc(day) - [user_cod] - [user_cate] - [user_ce_inc]).sample
      user_eq_sap = (get_users_eq_sap(day) - [user_cod] - [user_cate] - [user_ce_inc] - [user_eq_inc]).sample
      user_stg = (get_users_stg(day) - [user_cod] - [user_cate] - [user_ce_inc] - [user_eq_inc] - [user_eq_sap]).sample
      @care.users << user_cod unless get_users_cod(day).empty? || user_cod.nil?
      @care.users << user_cate unless get_users_cate(day).empty? || user_cate.nil?
      @care.users << user_ce_inc unless get_users_ce_inc(day).empty? || user_ce_inc.nil?
      @care.users << user_eq_inc unless get_users_eq_inc(day).empty? || user_eq_inc.nil?
      @care.users << user_eq_sap unless get_users_eq_sap(day).empty? || user_eq_sap.nil?
      @care.users << user_stg unless get_users_stg(day).empty? || user_stg.nil?
      @care.save
    end
    redirect_to @care
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
    User.where('"EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1").select do |user|
      user.availabilties.map { |a| a.day.strftime('%d-%m-%Y') }.include?(day.strftime('%d-%m-%Y'))
    end
  end

  def get_users_stg(day)
    User.where(STG:"1").select do |user|
      user.availabilties.map { |a| a.day.strftime('%d-%m-%Y') }.include?(day.strftime('%d-%m-%Y'))
    end
  end
end
