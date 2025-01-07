class ReportsController < ApplicationController
  def table_pdf
    cares = Care.where(id: params[:cares])
    pdf = PdfGenerator.new(params[:roles], cares, params[:week_size].to_i).generate
    send_data pdf, filename: "#{cares.first.day.strftime('%Y_%m')}_gardes.pdf", type: "application/pdf", disposition: "attachment"
  end
end
