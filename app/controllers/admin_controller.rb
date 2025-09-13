class AdminController < ApplicationController
  def index

    @month = I18n.l(Date.today.beginning_of_month, format: '%B')
    @alert_message = "L'action va générér des disponibilités et des gardes pour le mois de #{@month}."
  end
  def create_data

  end
end
