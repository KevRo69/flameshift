class AdminController < ApplicationController
  before_action :authorize_user

  def index
    @month = I18n.l(Date.today.beginning_of_month, format: '%B')
    @alert_message = "L'action va générer des disponibilités et des gardes pour le mois de #{@month} et des disponibilités pour le mois suivant."
    @availabilities_present = Availabilty.where(day: Date.today.beginning_of_month..Date.today.end_of_month).present?
  end
  def create_data
    users = User.where(deactivated: false).reject { |user| user.email == "nil" }
    start_date = Date.new(2025, Date.today.month, 1)
    Availabilties::CreateFakeAvailabilties.new(users, start_date).execute
    Availabilties::CreateFakeAvailabilties.new(users, start_date >> 1).execute
    Cares::CreateFakeCares.new(users, start_date).execute
    redirect_to admin_path, notice: "Les disponibilités et les gardes ont été générées avec succès."
  end

  private

  def authorize_user
    unless current_user&.super_admin?
      redirect_to root_path, alert: "Vous n'êtes pas autorisé à accéder à cette page."
    end
  end
end
