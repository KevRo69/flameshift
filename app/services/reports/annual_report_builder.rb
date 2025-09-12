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
      users.each_with_object({}) do |user, hash|
        next if user.first_name == "/"
        yearly_cares = user.cares.where("EXTRACT(YEAR FROM day) = ?", @year).count
        hash[user.id] = {
          yearly_cares: yearly_cares,
          saturday_cares: user.cares.where("EXTRACT(YEAR FROM day) = ? AND EXTRACT(DOW FROM day) = ?", @year, 6).count,
          sunday_cares: user.cares.where("EXTRACT(YEAR FROM day) = ? AND EXTRACT(DOW FROM day) = ?", @year, 0).count
        }
      end
    end

    def build_maneuvers(users)
      users.each_with_object({}) do |user, hash|
        hash[user.id] = {
          yearly_maneuvers: user.user_maneuvers.where("year = ?", @year).first.nil? ? 0 : user.user_maneuvers.where("year = ?", @year).first.number
        }
      end
    end
  end
end
