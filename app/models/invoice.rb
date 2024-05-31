# xml_document: :text
# xml_valid: :boolean
class Invoice < ApplicationRecord
  include FacturxJsonConcern
  include FacturxXmlConcern

  has_one_attached :pdf_document

  after_create_commit :extract_xml

  private

  def extract_xml
    return unless pdf_document.attached?

    if xml_document.present?
      validate_xml
    elsif pdf_document.blob.content_type == 'application/pdf'
      PdfBlobToXmlJob.perform_now(self)
    end
  end

  def validate_xml
  end
end
