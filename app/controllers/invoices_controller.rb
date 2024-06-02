class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.order(created_at: :desc)
  end

  def import
    files = params[:files]
    files = files.compact_blank
    files.each do |file|
      case file.content_type
      when 'application/pdf'
        Invoice.create(pdf_document: file)
      when 'text/xml' || 'application/xml'
        Invoice.create(xml_document: File.read(file))
      end
    end

    redirect_to invoices_url, notice: 'Invoices imported.'
  end

  def show
    @invoice = Invoice.find(params[:id])
  end
end
