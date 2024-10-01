puts "Destroying all users..."
User.destroy_all

puts "Destroying all teams..."
Team.destroy_all

puts "Creating teams..."
Team.create!(number: 1)
Team.create!(number: 2)
Team.create!(number: 3)

puts "Creating users..."

User.create!(email: "user1@test.fr", password: "123456", first_name: "Denis", last_name: "Dannaud", CATE: "1", COD_1: "1", team_id: Team.where(number: 3)[0].id)
User.create!(email: "user2@test.fr", password: "123456", first_name: "David", last_name: "Quibel", CATE: "1", COD_1: "1", validator: "1", team_id: Team.where(number: 2)[0].id)
User.create!(email: "user3@test.fr", password: "123456", first_name: "Franck", last_name: "Combe", CATE: "1", COD_1: "1", team_id: Team.where(number: 1)[0].id)
User.create!(email: "user4@test.fr", password: "123456", first_name: "Stéphane", last_name: "Janaudy", CA1E: "1", team_id: Team.where(number: 3)[0].id)
User.create!(email: "user5@test.fr", password: "123456", first_name: "Raphael", last_name: "Poulin", CATE: "1", COD_1: "1", CA1E: "1", team_id: Team.where(number: 2)[0].id)
User.create!(email: "user6@test.fr", password: "123456", first_name: "Nicolas", last_name: "Debost", CE_INC: "1", COD_1: "1", team_id: Team.where(number: 1)[0].id)
User.create!(email: "user7@test.fr", password: "123456", first_name: "Alexandre", last_name: "Barbier", CE_INC: "1", COD_1: "1", team_id: Team.where(number: 3)[0].id)
User.create!(email: "user8@test.fr", password: "123456", first_name: "Meggane", last_name: "Devillard", EQ_INC: "1", COD_1: "1", team_id: Team.where(number: 1)[0].id)
User.create!(email: "user9@test.fr", password: "123456", first_name: "Sebastien", last_name: "Desbois", CA1E: "1", team_id: Team.where(number: 1)[0].id)
User.create!(email: "user10@test.fr", password: "123456", first_name: "Sandrine", last_name: "Legras", CE_INC: "1", team_id: Team.where(number: 2)[0].id)
User.create!(email: "user11@test.fr", password: "123456", first_name: "Quentin", last_name: "Vasseur", CE_INC: "1", validator: "1", team_id: Team.where(number: 2)[0].id)
User.create!(email: "user12@test.fr", password: "123456", first_name: "Faustine", last_name: "Desrayaud", CE_INC: "1", validator: "1", team_id: Team.where(number: 1)[0].id)
User.create!(email: "user13@test.fr", password: "123456", first_name: "Sonia", last_name: "Janaudy", EQ_INC: "1", team_id: Team.where(number: 3)[0].id)
User.create!(email: "user14@test.fr", password: "123456", first_name: "Vincent", last_name: "Costechareyre", team_id: Team.where(number: 3)[0].id)
User.create!(email: "user15@test.fr", password: "123456", first_name: "Olivier", last_name: "Lacroix", EQ_SAP: "1", team_id: Team.where(number: 2)[0].id)
User.create!(email: "user16@test.fr", password: "123456", first_name: "Guillaume", last_name: "Morel", EQ_SAP: "1", team_id: Team.where(number: 3)[0].id)
User.create!(email: "user17@test.fr", password: "123456", first_name: "Maxence", last_name: "Rodriguez", STG: "1", team_id: Team.where(number: 1)[0].id)
User.create!(email: "user18@test.fr", password: "123456", first_name: "Aaron", last_name: "Hugenin", STG: "1", team_id: Team.where(number: 2)[0].id)

puts "Users created!"

puts "Creating availabilities..."

User.all.each do |user|
  rand(30).times do
    random_date = Faker::Date.between(from: '2024-11-01', to: '2024-11-30')
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
