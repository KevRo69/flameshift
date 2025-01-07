if Rails.env.production?
  puts "Creating teams..."
  Team.create!(number: 1)
  Team.create!(number: 2)
  Team.create!(number: 3)
  Team.create!(number: 4)

  puts "Creating users..."
  User.create!(email: "nil", password: "123456", first_name: "/", last_name: "/", EQ_SAP: "1", STG: "1", team_id: Team.where(number: 4)[0].id)
  User.create!(email: "denisd", password: "123456", first_name: "Denis", last_name: "Dannaud", CATE: "1", COD_1: "1", team_id: Team.where(number: 3)[0].id)
  User.create!(email: "davidq", password: "123456", first_name: "David", last_name: "Quibel", CATE: "1", COD_1: "1", validator: "1", team_id: Team.where(number: 2)[0].id)
  User.create!(email: "franckc", password: "123456", first_name: "Franck", last_name: "Combe", CATE: "1", COD_1: "1", team_id: Team.where(number: 1)[0].id)
  User.create!(email: "stephanej", password: "123456", first_name: "Stéphane", last_name: "Janaudy", CA1E: "1", team_id: Team.where(number: 3)[0].id)
  User.create!(email: "nicolasd", password: "123456", first_name: "Nicolas", last_name: "Debost", CE_INC: "1", EQ_INC: "1", EQ_SAP: "1", COD_1: "1", team_id: Team.where(number: 1)[0].id)
  User.create!(email: "alexandreb", password: "123456", first_name: "Alexandre", last_name: "Barbier", CE_INC: "1", EQ_INC: "1", EQ_SAP: "1", COD_1: "1", team_id: Team.where(number: 3)[0].id)
  User.create!(email: "megganed", password: "123456", first_name: "Meggane", last_name: "Devillard", EQ_INC: "1", COD_1: "1", team_id: Team.where(number: 1)[0].id)
  User.create!(email: "sebastiend", password: "123456", first_name: "Sebastien", last_name: "Desbois", CA1E: "1", team_id: Team.where(number: 1)[0].id)
  User.create!(email: "sandrinel", password: "123456", first_name: "Sandrine", last_name: "Legras", CE_INC: "1", EQ_INC: "1", EQ_SAP: "1", team_id: Team.where(number: 2)[0].id)
  User.create!(email: "quentinv", password: "123456", first_name: "Quentin", last_name: "Vasseur", CE_INC: "1", EQ_INC: "1", EQ_SAP: "1", validator: "1", team_id: Team.where(number: 2)[0].id)
  User.create!(email: "faustined", password: "123456", first_name: "Faustine", last_name: "Desrayaud", CE_INC: "1", EQ_INC: "1", EQ_SAP: "1", validator: "1", team_id: Team.where(number: 1)[0].id)
  User.create!(email: "soniaj", password: "123456", first_name: "Sonia", last_name: "Janaudy", EQ_INC: "1", team_id: Team.where(number: 3)[0].id)
  User.create!(email: "vincentc", password: "123456", first_name: "Vincent", last_name: "Costechareyre", EQ_INC: "1", EQ_SAP: "1", team_id: Team.where(number: 3)[0].id)
  User.create!(email: "olivierl", password: "123456", first_name: "Olivier", last_name: "Lacroix", EQ_SAP: "1", team_id: Team.where(number: 2)[0].id)
  User.create!(email: "guillaumem", password: "123456", first_name: "Guillaume", last_name: "Morel", EQ_SAP: "1", team_id: Team.where(number: 3)[0].id)
  User.create!(email: "maxencer", password: "123456", first_name: "Maxence", last_name: "Rodriguez", STG: "1", team_id: Team.where(number: 1)[0].id)
  User.create!(email: "aaronh", password: "123456", first_name: "Aaron", last_name: "Hugenin", STG: "1", team_id: Team.where(number: 2)[0].id)

  puts "Users created!"
else
  puts "Destroying all users..."
  User.destroy_all
  User.only_deleted.each(&:really_destroy!)

  puts "Destroying all teams..."
  Team.destroy_all

  puts "Destroying all cares..."
  Care.destroy_all

  puts "Creating teams..."
  Team.create!(number: 1)
  Team.create!(number: 2)
  Team.create!(number: 3)
  Team.create!(number: 4)

  puts "Creating users..."
  User.create!(email: "nil", password: "123456", first_name: "/", last_name: "/", EQ_SAP: "1", STG: "1", team_id: Team.where(number: 4)[0].id)
  User.create!(email: "denisd", password: "123456", first_name: "Denis", last_name: "Dannaud", CATE: "1", COD_1: "1", team_id: Team.where(number: 3)[0].id)
  User.create!(email: "davidq", password: "123456", first_name: "David", last_name: "Quibel", CATE: "1", COD_1: "1", validator: "1", team_id: Team.where(number: 2)[0].id)
  User.create!(email: "franckc", password: "123456", first_name: "Franck", last_name: "Combe", CATE: "1", COD_1: "1", team_id: Team.where(number: 1)[0].id)
  User.create!(email: "stephanej", password: "123456", first_name: "Stéphane", last_name: "Janaudy", CA1E: "1", team_id: Team.where(number: 3)[0].id)
  User.create!(email: "nicolasd", password: "123456", first_name: "Nicolas", last_name: "Debost", CE_INC: "1", EQ_INC: "1", EQ_SAP: "1", COD_1: "1", team_id: Team.where(number: 1)[0].id)
  User.create!(email: "alexandreb", password: "123456", first_name: "Alexandre", last_name: "Barbier", CE_INC: "1", EQ_INC: "1", EQ_SAP: "1", COD_1: "1", team_id: Team.where(number: 3)[0].id)
  User.create!(email: "megganed", password: "123456", first_name: "Meggane", last_name: "Devillard", EQ_INC: "1", COD_1: "1", team_id: Team.where(number: 1)[0].id)
  User.create!(email: "sebastiend", password: "123456", first_name: "Sebastien", last_name: "Desbois", CA1E: "1", team_id: Team.where(number: 1)[0].id)
  User.create!(email: "sandrinel", password: "123456", first_name: "Sandrine", last_name: "Legras", CE_INC: "1", EQ_INC: "1", EQ_SAP: "1", team_id: Team.where(number: 2)[0].id)
  User.create!(email: "quentinv", password: "123456", first_name: "Quentin", last_name: "Vasseur", CE_INC: "1", EQ_INC: "1", EQ_SAP: "1", validator: "1", team_id: Team.where(number: 2)[0].id)
  User.create!(email: "faustined", password: "123456", first_name: "Faustine", last_name: "Desrayaud", CE_INC: "1", EQ_INC: "1", EQ_SAP: "1", validator: "1", team_id: Team.where(number: 1)[0].id)
  User.create!(email: "soniaj", password: "123456", first_name: "Sonia", last_name: "Janaudy", EQ_INC: "1", team_id: Team.where(number: 3)[0].id)
  User.create!(email: "vincentc", password: "123456", first_name: "Vincent", last_name: "Costechareyre", EQ_INC: "1", EQ_SAP: "1", team_id: Team.where(number: 3)[0].id)
  User.create!(email: "olivierl", password: "123456", first_name: "Olivier", last_name: "Lacroix", EQ_SAP: "1", team_id: Team.where(number: 2)[0].id)
  User.create!(email: "guillaumem", password: "123456", first_name: "Guillaume", last_name: "Morel", EQ_SAP: "1", team_id: Team.where(number: 3)[0].id)
  User.create!(email: "maxencer", password: "123456", first_name: "Maxence", last_name: "Rodriguez", STG: "1", team_id: Team.where(number: 1)[0].id)
  User.create!(email: "aaronh", password: "123456", first_name: "Aaron", last_name: "Hugenin", STG: "1", team_id: Team.where(number: 2)[0].id)

  puts "Users created!"

  # puts "Creating cares for November..."

  # 31.times do |i|
  #   care = Care.new(day: "2024-11-#{i + 1}")
  #   user_ce = User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1").sample
  #   user_eq = (User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1") - [user_ce]).sample
  #   user_sap = (User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1") - [user_ce] - [user_eq]).sample

  #   care.users << User.where(COD_1: "1").sample
  #   care.users << User.where(CATE: "1").sample
  #   care.users << user_ce
  #   care.users << user_eq
  #   care.users << user_sap
  #   care.users << User.where(STG: "1").sample
  #   care.save
  # end

  # puts "Cares for November created!"

  puts "Creating cares for year..."

  3.times do |i|
    care = Care.new(day: "2025-01-#{i + 3}")
    user_ce = User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1").sample
    user_eq = (User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1") - [user_ce]).sample
    user_sap = (User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1") - [user_ce] - [user_eq]).sample

    care.users << User.where(COD_1: "1").sample
    care.users << User.where(CATE: "1").sample
    care.users << user_ce
    care.users << user_eq
    care.users << user_sap
    care.users << User.where(STG: "1").sample
    care.save
  end
  28.times do |i|
    care = Care.new(day: "2025-02-#{i + 1}")
    user_ce = User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1").sample
    user_eq = (User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1") - [user_ce]).sample
    user_sap = (User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1") - [user_ce] - [user_eq]).sample

    care.users << User.where(COD_1: "1").sample
    care.users << User.where(CATE: "1").sample
    care.users << user_ce
    care.users << user_eq
    care.users << user_sap
    care.users << User.where(STG: "1").sample
    care.save
  end
  31.times do |i|
    care = Care.new(day: "2025-03-#{i + 1}")
    user_ce = User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1").sample
    user_eq = (User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1") - [user_ce]).sample
    user_sap = (User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1") - [user_ce] - [user_eq]).sample

    care.users << User.where(COD_1: "1").sample
    care.users << User.where(CATE: "1").sample
    care.users << user_ce
    care.users << user_eq
    care.users << user_sap
    care.users << User.where(STG: "1").sample
    care.save
  end
  30.times do |i|
    care = Care.new(day: "2025-04-#{i + 1}")
    user_ce = User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1").sample
    user_eq = (User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1") - [user_ce]).sample
    user_sap = (User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1") - [user_ce] - [user_eq]).sample

    care.users << User.where(COD_1: "1").sample
    care.users << User.where(CATE: "1").sample
    care.users << user_ce
    care.users << user_eq
    care.users << user_sap
    care.users << User.where(STG: "1").sample
    care.save
  end
  31.times do |i|
    care = Care.new(day: "2025-05-#{i + 1}")
    user_ce = User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1").sample
    user_eq = (User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1") - [user_ce]).sample
    user_sap = (User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1") - [user_ce] - [user_eq]).sample

    care.users << User.where(COD_1: "1").sample
    care.users << User.where(CATE: "1").sample
    care.users << user_ce
    care.users << user_eq
    care.users << user_sap
    care.users << User.where(STG: "1").sample
    care.save
  end
  30.times do |i|
    care = Care.new(day: "2025-06-#{i + 1}")
    user_ce = User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1").sample
    user_eq = (User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1") - [user_ce]).sample
    user_sap = (User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1") - [user_ce] - [user_eq]).sample

    care.users << User.where(COD_1: "1").sample
    care.users << User.where(CATE: "1").sample
    care.users << user_ce
    care.users << user_eq
    care.users << user_sap
    care.users << User.where(STG: "1").sample
    care.save
  end
  31.times do |i|
    care = Care.new(day: "2025-07-#{i + 1}")
    user_ce = User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1").sample
    user_eq = (User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1") - [user_ce]).sample
    user_sap = (User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1") - [user_ce] - [user_eq]).sample

    care.users << User.where(COD_1: "1").sample
    care.users << User.where(CATE: "1").sample
    care.users << user_ce
    care.users << user_eq
    care.users << user_sap
    care.users << User.where(STG: "1").sample
    care.save
  end
  31.times do |i|
    care = Care.new(day: "2025-08-#{i + 1}")
    user_ce = User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1").sample
    user_eq = (User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1") - [user_ce]).sample
    user_sap = (User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1") - [user_ce] - [user_eq]).sample

    care.users << User.where(COD_1: "1").sample
    care.users << User.where(CATE: "1").sample
    care.users << user_ce
    care.users << user_eq
    care.users << user_sap
    care.users << User.where(STG: "1").sample
    care.save
  end
  30.times do |i|
    care = Care.new(day: "2025-09-#{i + 1}")
    user_ce = User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1").sample
    user_eq = (User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1") - [user_ce]).sample
    user_sap = (User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1") - [user_ce] - [user_eq]).sample

    care.users << User.where(COD_1: "1").sample
    care.users << User.where(CATE: "1").sample
    care.users << user_ce
    care.users << user_eq
    care.users << user_sap
    care.users << User.where(STG: "1").sample
    care.save
  end
  31.times do |i|
    care = Care.new(day: "2025-10-#{i + 1}")
    user_ce = User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1").sample
    user_eq = (User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1") - [user_ce]).sample
    user_sap = (User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1") - [user_ce] - [user_eq]).sample

    care.users << User.where(COD_1: "1").sample
    care.users << User.where(CATE: "1").sample
    care.users << user_ce
    care.users << user_eq
    care.users << user_sap
    care.users << User.where(STG: "1").sample
    care.save
  end
  30.times do |i|
    care = Care.new(day: "2025-11-#{i + 1}")
    user_ce = User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1").sample
    user_eq = (User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1") - [user_ce]).sample
    user_sap = (User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1") - [user_ce] - [user_eq]).sample

    care.users << User.where(COD_1: "1").sample
    care.users << User.where(CATE: "1").sample
    care.users << user_ce
    care.users << user_eq
    care.users << user_sap
    care.users << User.where(STG: "1").sample
    care.save
  end
  31.times do |i|
    care = Care.new(day: "2025-12-#{i + 1}")
    user_ce = User.where('"CE_INC" = ? OR "CA1E" = ?', "1", "1").sample
    user_eq = (User.where('"CE_INC" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1") - [user_ce]).sample
    user_sap = (User.where('"CE_INC" = ? OR "EQ_SAP" = ? OR "EQ_INC" = ? OR "CA1E" = ?', "1", "1", "1", "1") - [user_ce] - [user_eq]).sample

    care.users << User.where(COD_1: "1").sample
    care.users << User.where(CATE: "1").sample
    care.users << user_ce
    care.users << user_eq
    care.users << user_sap
    care.users << User.where(STG: "1").sample
    care.save
  end

  puts "Cares for December created!"

  puts "Creating availabilities..."

  User.all.each do |user|
    rand(100).times do
      random_date = Faker::Date.between(from: '2025-02-01', to: '2025-02-28')
      user.availabilties.create!(day: random_date)
    end
    # Find days that have duplicates
    user.availabilties.group(:day).having('COUNT(*) > 1').pluck(:day).each do |day|
      # Get all availabilities for that day, sorted by ID
      duplicates = user.availabilties.where(day: day).order(:id)
      # Keep the first one, delete the rest
      duplicates.offset(1).delete_all
    end
  end

  puts "Availabilities created!"

  # puts "Creating availabilities for February..."

  # User.all.each do |user|
  #   rand(100).times do
  #     random_date = Faker::Date.between(from: '2025-02-01', to: '2025-02-28')
  #     user.availabilties.create!(day: random_date)
  #   end
  #   # Find days that have duplicates
  #   user.availabilties.group(:day).having('COUNT(*) > 1').pluck(:day).each do |day|
  #     # Get all availabilities for that day, sorted by ID
  #     duplicates = user.availabilties.where(day: day).order(:id)
  #     # Keep the first one, delete the rest
  #     duplicates.offset(1).delete_all
  #   end
  # end

  # puts "Availabilities created!"
end
