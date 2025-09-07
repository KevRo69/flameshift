require 'prawn'

class AnnualPdfGenerator
  def initialize()
  end

  def generate
    Prawn::Document.new(page_layout: :landscape) do |pdf|

    end.render
  end

  private

  def table_data(week_cares)

  end
end
