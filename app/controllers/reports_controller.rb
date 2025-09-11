class ReportsController < ApplicationController
  def table_pdf
    cares = Care.where(id: params[:cares]).sort_by(&:day)
    pdf = PdfGenerator.new(params[:roles], cares, params[:week_size].to_i).generate
    send_data pdf, filename: "#{cares.first.day.strftime('%Y_%m')}_gardes.pdf", type: "application/pdf", disposition: "attachment"
  end

  def annual_table_pdf
    year = params[:year].to_i
    report = Reports::AnnualReportBuilder.new(year: year).build

    pdf = AnnualPdfGenerator.new(
      report[:users],
      report[:cares_data],
      report[:maneuvers],
      year
    ).generate

    send_data pdf,
              filename: "Recap_annuel_#{year}.pdf",
              type: "application/pdf",
              disposition: "attachment"
  end
end
