class AvailabiltiesController < ApplicationController
  def index
    @availabilities = Availabilty.all
  end

  def new
    @user = current_user
    @availability = Availabilty.new
  end

  def create
    start_of_next = Date.today.day < 16 ? Date.today.beginning_of_month + 1.months : Date.today.beginning_of_month + 2.months
    end_of_next = Date.today.day < 16 ? Date.today.end_of_month + 1.months : Date.today.end_of_month + 2.months
    availabilities_next = current_user.availabilties.where(day: (start_of_next)..(end_of_next))
    avaibilities_next_days = availabilities_next.map { |date| date.day.strftime('%Y-%m-%d') }
    availabilities = availability_params[:day].split(", ")
    saturdays = availabilities.select { |day| Date.parse(day).saturday? }
    sundays = availabilities.select { |day| Date.parse(day).sunday? }
    @no_weekend = !((saturdays.size > 0 && sundays.size > 0) || (saturdays.size == 0 && sundays.size > 1))
    days_to_destroy = avaibilities_next_days - availabilities
    days_to_destroy.each do |day|
      Availabilty.find_by(day: day, user:current_user).destroy
    end
    availabilities.each do |day|
      if availabilities_next.select { |t| t.day.strftime('%Y-%m-%d') == day }.empty?
        availability = Availabilty.new(day: day, user: current_user)
        availability.save
      end
    end
    if @no_weekend
      flash[:alert] = "Il faut au moins un samedi et un dimanche ou deux dimanches dans le mois."
    end
    redirect_to user_path(current_user)
  end

  def create2
    start_of_next = Date.today.day < 16 ? Date.today.beginning_of_month + 2.months : Date.today.beginning_of_month + 3.months
    end_of_next = Date.today.day < 16 ? Date.today.end_of_month + 2.months : Date.today.end_of_month + 3.months
    availabilities_next = current_user.availabilties.where(day: (start_of_next)..(end_of_next))
    avaibilities_next_days = availabilities_next.map { |date| date.day.strftime('%Y-%m-%d') }
    availabilities = availability_params[:day].split(", ")
    saturdays = availabilities.select { |day| Date.parse(day).saturday? }
    sundays = availabilities.select { |day| Date.parse(day).sunday? }
    @no_weekend = !((saturdays.size > 0 && sundays.size > 0) || (saturdays.size == 0 && sundays.size > 1))
    days_to_destroy = avaibilities_next_days - availabilities
    days_to_destroy.each do |day|
      Availabilty.find_by(day: day, user:current_user).destroy
    end
    availabilities.each do |day|
      if availabilities_next.select { |t| t.day.strftime('%Y-%m-%d') == day }.empty?
        availability = Availabilty.new(day: day, user: current_user)
        availability.save
      end
    end
    if @no_weekend
      flash[:alert] = "Il faut au moins un samedi et un dimanche ou deux dimanches dans le mois."
    end
    redirect_to user_path(current_user)
  end

  def create3
    start_of_next = Date.today.day < 16 ? Date.today.beginning_of_month + 3.months : Date.today.beginning_of_month + 4.months
    end_of_next = Date.today.day < 16 ? Date.today.end_of_month + 3.months : Date.today.end_of_month + 4.months
    availabilities_next = current_user.availabilties.where(day: (start_of_next)..(end_of_next))
    avaibilities_next_days = availabilities_next.map { |date| date.day.strftime('%Y-%m-%d') }
    availabilities = availability_params[:day].split(", ")
    saturdays = availabilities.select { |day| Date.parse(day).saturday? }
    sundays = availabilities.select { |day| Date.parse(day).sunday? }
    @no_weekend = !((saturdays.size > 0 && sundays.size > 0) || (saturdays.size == 0 && sundays.size > 1))
    days_to_destroy = avaibilities_next_days - availabilities
    days_to_destroy.each do |day|
      Availabilty.find_by(day: day, user:current_user).destroy
    end
    availabilities.each do |day|
      if availabilities_next.select { |t| t.day.strftime('%Y-%m-%d') == day }.empty?
        availability = Availabilty.new(day: day, user: current_user)
        availability.save
      end
    end
    if @no_weekend
      flash[:alert] = "Il faut au moins un samedi et un dimanche ou deux dimanches dans le mois."
    end
    redirect_to user_path(current_user)
  end

  def edit
    @user = current_user
    @availability = Availabilty.new

    start_of_next = Date.today.day < 16 ? Date.today.beginning_of_month + 1.months : Date.today.beginning_of_month + 2.months
    end_of_next = Date.today.day < 16 ? Date.today.end_of_month + 1.months : Date.today.end_of_month + 2.months

    @availabilities_next = @user.availabilties.where(day: (start_of_next)..(end_of_next)).uniq { |t| t.day }.sort_by(&:day)
    @availabilities_next_days = @availabilities_next.map { |date| date.day }

    @users_cod = get_number_user_available_per_day("COD_1")
    @users_cate = get_number_user_available_per_day("CATE")
    @users_ca1e = get_number_user_available_per_day("CA1E")
    @users_ce_inc = get_number_user_available_per_day("CE_INC")
    @users_eq_inc = get_number_user_available_per_day("EQ_INC")
    @users_eq_sap = get_number_user_available_per_day("EQ_SAP")
    @users_stg = get_number_user_available_per_day("STG")
  end

  def edit2
    @user = current_user
    @availability = Availabilty.new

    start_of_next2 = Date.today.day < 16 ? Date.today.beginning_of_month + 2.months : Date.today.beginning_of_month + 3.months
    end_of_next2 = Date.today.day < 16 ? Date.today.end_of_month + 2.months : Date.today.end_of_month + 3.months
    @month_next2 = I18n.t('date.month_names')[start_of_next2.month]

    @availabilities_next2 = @user.availabilties.where(day: (start_of_next2)..(end_of_next2)).uniq { |t| t.day }.sort_by(&:day)
    @availabilities_next_days2 = @availabilities_next2.map { |date| date.day }

    @users_cod = get_number_user_available_per_day("COD_1")
    @users_cate = get_number_user_available_per_day("CATE")
    @users_ca1e = get_number_user_available_per_day("CA1E")
    @users_ce_inc = get_number_user_available_per_day("CE_INC")
    @users_eq_inc = get_number_user_available_per_day("EQ_INC")
    @users_eq_sap = get_number_user_available_per_day("EQ_SAP")
    @users_stg = get_number_user_available_per_day("STG")
  end

  def edit3
  @user = current_user
  @availability = Availabilty.new

  start_of_next3 = Date.today.day < 16 ? Date.today.beginning_of_month + 3.months : Date.today.beginning_of_month + 4.months
  end_of_next3 = Date.today.day < 16 ? Date.today.end_of_month + 3.months : Date.today.end_of_month + 4.months
  @month_next3 = I18n.t('date.month_names')[start_of_next3.month]

  @availabilities_next3 = @user.availabilties.where(day: (start_of_next3)..(end_of_next3)).uniq { |t| t.day }.sort_by(&:day)
  @availabilities_next_days3 = @availabilities_next3.map { |date| date.day }

  @users_cod = get_number_user_available_per_day("COD_1")
  @users_cate = get_number_user_available_per_day("CATE")
  @users_ca1e = get_number_user_available_per_day("CA1E")
  @users_ce_inc = get_number_user_available_per_day("CE_INC")
  @users_eq_inc = get_number_user_available_per_day("EQ_INC")
  @users_eq_sap = get_number_user_available_per_day("EQ_SAP")
  @users_stg = get_number_user_available_per_day("STG")
end

  private

  def availability_params
    params.require(:availabilty).permit(:day, :user_id)
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
