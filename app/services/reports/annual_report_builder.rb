module Reports
  class AnnualReportBuilder
    def initialize(year:)
      @year = year
    end

    def build
      users = User.all.sort_by(&:last_name)

      cares_data = build_cares_data(users)
      maneuvers  = build_maneuvers(users)

      { users: users, cares_data: cares_data, maneuvers: maneuvers }
    end

    private

    def build_cares_data(users)
      user_cares = UserCare
                     .joins(:care, :user)
                     .where("EXTRACT(YEAR FROM cares.day) = ?", @year)
                     .select('user_cares.*, cares.day AS "day", users.first_name, users.last_name')

      grouped = user_cares.group_by(&:user_id)

      data = grouped.each_with_object({}) do |(user_id, cares), hash|
        next if cares.first.first_name == "/"

        hash[user_id] = {
          yearly_cares: cares.size,
          friday_cares: cares.count { |user_care| user_care.day.wday == 5 },
          saturday_cares: cares.count { |user_care| user_care.day.wday == 6 },
          sunday_cares: cares.count { |user_care| user_care.day.wday == 0 }
        }
      end

      # 💡 Ajouter les users sans cares
      users.each do |user|
        next if user.first_name == "/"
        data[user.id] ||= { yearly_cares: 0, friday_cares: 0, saturday_cares: 0, sunday_cares: 0 }
      end

      data
    end

    def build_maneuvers(users)
      user_maneuvers = UserManeuver
                         .joins(:user)
                         .where("year = ?", @year)
                         .select('user_maneuvers.*, users.first_name, users.last_name')
      grouped = user_maneuvers.group_by(&:user_id)

      data = grouped.each_with_object({}) do |(user_id, maneuvers), hash|
        next if maneuvers.first.first_name == "/"

        hash[user_id] = {
          yearly_maneuvers: maneuvers.sum(&:number)
        }
      end

      users.each do |user|
        next if user.first_name == "/"
        data[user.id] ||= { yearly_maneuvers: 0 }
      end

      data
    end
  end
end
