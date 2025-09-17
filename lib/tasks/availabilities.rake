namespace :availabilities do
  desc "Met à jour des disponibilités dans la DB"
  task create_yearly_availabilities: :environment do
    puts "Début de la mise à jour..."

    start_date = Date.today.beginning_of_month >> 2
    end_date = (start_date >> 12) - 1.days

    #Delete all existing availabilities in the range to avoid duplicates
    availabilities = Availabilty.where(day: start_date..end_date)
    availabilities.delete_all

    puts "Suppression des anciennes disponibilités terminée."

    puts "Création des nouvelles disponibilités..."

    #Create availabilities for all users all year
    users = User.where(deactivated: false).reject { |user| user.email == "nil" }
    users.each do |user|
      (start_date..end_date).each do |date|
        user.availabilties.find_or_create_by(day: date)
      end
    end

    puts "Mise à jour terminée !"
  end
end
