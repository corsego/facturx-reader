class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def import
    files = params[:files]
    files = files.reject(&:blank?)
    files.each do |file|
      next unless file.content_type == "application/pdf"

      Invoice.create(pdf_document: file)
    end
  end

  def show
    @invoice = Invoice.find(params[:id])
  end
end
