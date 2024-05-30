require 'nokogiri'
# mark invalid if no xml

# xml_document: text
class Invoice < ApplicationRecord
  has_one_attached :pdf_document

  after_create_commit :extract_xml

  def parsed_xml
    Nokogiri::XML(xml_document)
  end

  def iban
    parsed_xml.xpath('//ram:IBANID').text
  end

  def account_name
    parsed_xml.xpath('//ram:AccountName').text
  end

  private

  def extract_xml
    if pdf_document.attached?
      PdfBlobToXmlJob.perform_now(self)
    end
  end
end
