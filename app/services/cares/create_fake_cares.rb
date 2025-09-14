module Cares
  class CreateFakeCares
    def initialize(users, start_date)
      @users = users
      @start_date = start_date
      @end_date = start_date.end_of_month
    end

    def execute
      create_cares
    end

    private

    def create_cares
      month_days = (@start_date..@end_date).to_a
      care_days = @start_date.mon == 7 || @start_date.mon == 8 ? month_days : month_days.select { |day| [5, 6, 0].include?(day.wday) }
      usernil = User.where(email:"nil").first

      care_days.each do |care_day|
        care = Care.new(day: care_day)
        user_cod = weight_care(care_day, get_users_cod(care_day))
        user_cate = weight_care(care_day, (get_users_cate(care_day) - [user_cod]))
        user_ce_inc = weight_care(care_day, (get_users_ce_inc(care_day) - [user_cod] - [user_cate]))
        user_eq_inc = weight_care(care_day, (get_users_eq_inc(care_day) - [user_cod] - [user_cate] - [user_ce_inc]))
        user_eq_sap = weight_care(care_day, (get_users_eq_sap(care_day) - [user_cod] - [user_cate] - [user_ce_inc] - [user_eq_inc]))
        user_stg = weight_care(care_day, (get_users_stg(care_day) - [user_cod] - [user_cate] - [user_ce_inc] - [user_eq_inc] - [user_eq_sap]))
        unless get_users_cod(care_day).empty? || user_cod.nil?
          care.users << user_cod
        else
          care.users << usernil
        end
        unless get_users_cate(care_day).empty? || user_cate.nil?
          care.users << user_cate
        else
          care.users << usernil
        end
        unless get_users_ce_inc(care_day).empty? || user_ce_inc.nil?
          care.users << user_ce_inc
        else
          care.users << usernil
        end
        unless get_users_eq_inc(care_day).empty? || user_eq_inc.nil?
          care.users << user_eq_inc
        else
          care.users << usernil
        end
        unless get_users_eq_sap(care_day).empty? || user_eq_sap.nil?
          care.users << user_eq_sap
        else
          care.users << usernil
        end
        unless get_users_stg(care_day).empty? || user_stg.nil?
          care.users << user_stg
        else
          care.users << usernil
        end
        care.user_id = User.where(email:"nil").first.id
        care.save
      end
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
  end
end
