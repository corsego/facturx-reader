# xml_document: :text
# xml_valid: :boolean
class Invoice < ApplicationRecord
  include FacturxJsonConcern
  include FacturxXmlConcern

  has_one_attached :pdf_document

  after_create_commit :extract_xml

  private

  def extract_xml
    if pdf_document.attached?
      PdfBlobToXmlJob.perform_now(self)
    end
  end
end
