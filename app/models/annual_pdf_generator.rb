require 'prawn'

class AnnualPdfGenerator
  def initialize(users, cares_data, maneuvers, year)
    @users = users
    @cares_data = cares_data
    @maneuvers = maneuvers
    @year = year
  end

  def generate
    Prawn::Document.new(page_layout: :landscape) do |pdf|
      pdf.text "Récapitulatif annuel #{@year}", size: 20, style: :bold, align: :center
      pdf.move_down 20

      pdf.table(table_data, header: true, width: pdf.bounds.width) do
        row(0).font_style = :bold
        row(0).background_color = "B72614"
        row(0).text_color = 'FFFFFF'
        self.row_colors = ['F4F4F4', 'FFB0B0']
        self.cell_style = { size: 10, borders: [:left, :right, :top, :bottom], border_width: 0.5 }
      end
    end.render
  end

  private

  def table_data
    data = []
    data << ["Nom", "Nombre de gardes", "Nombre de samedis", "Nombre de dimanches", "Manœuvres"]

    @users.each do |user|
      next if user.first_name == "/"

      data << [
        "#{user.first_name.chars.first(2).join}. #{user.last_name}",
        @cares_data[user.id][:yearly_cares],
        @cares_data[user.id][:saturday_cares],
        @cares_data[user.id][:sunday_cares],
        @maneuvers[user.id][:yearly_maneuvers]
      ]
    end
    data
  end
end
