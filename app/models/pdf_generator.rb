require 'prawn'

class PdfGenerator
  def initialize(roles, cares, week_size)
    @roles = roles
    @cares = cares.to_a
    @week_size = week_size
  end

  def generate
    Prawn::Document.new(page_layout: :landscape) do |pdf|
      if @cares.first.day.wday == 0 && @week_size == 3
        # If the first care is a Sunday, first week is only one day (Sunday), then slice with week size
        weeks = [[@cares.first]] + @cares[1..].each_slice(@week_size).to_a
      elsif @cares.first.day.wday == 6 && @week_size == 3
        # If the first care is a Saturday, first week is Saturday and Sunday, then slice others with week size
        weeks = [[@cares.first, @cares[1]]] + @cares[2..].each_slice(@week_size).to_a
      else
        # Otherwise, slice normally by week size
        weeks = @cares.each_slice(@week_size).to_a
      end

      weeks.each_with_index do |week_cares, index|
        if index > 0
          pdf.start_new_page
        end

        # Add title for each week
        pdf.text "#{I18n.l(week_cares.first.day, format: '%B %Y')}\nGardes semaine #{index + 1}", size: 18, style: :bold, align: :center
        pdf.move_down 10

        # Generate table data for the current week
        pdf.table(table_data(week_cares), header: true, cell_style: { inline_format: true, size: 14, align: :center }, row_colors: ["F0F0F0", "FFFFFF"]) do
          row(0).font_style = :bold
          row(0).background_color = "CCCCCC"
          self.cell_style = { borders: [:top, :bottom, :left, :right] }
          columns(0).font_style = :bold
        end
      end
    end.render
  end

  private

  def table_data(week_cares)
    # Header row
    header = [""] + ([@week_size - week_cares.size].map { "" }) +
    week_cares.map { |care| "#{I18n.t('date.day_names')[care.day.wday]}\n#{care.day.strftime('%d-%m-%Y')}" }

    # Body rows
    body = @roles.each_with_index.map do |role, role_index|
      row = [role] # First column for role
      row += ([@week_size - week_cares.size].map { "" }) # Empty cells for padding
      row += week_cares.map do |care|
        user = care.users[role_index]
        if user
          if user.first_name != "/"
            "#{user.first_name.chars.first(2).join}. #{user.last_name}"
          else
            ""
          end
        else
          ""
        end
      end
      row
    end

    [header] + body
  end

end
