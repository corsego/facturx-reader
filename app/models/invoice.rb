# xml_document: :text
# xml_valid: :boolean
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

  def xml_document_to_json
    return '' if xml_document.nil?

    parser = Nori.new
    hash = parser.parse(xml_document)
    hash.to_json
    JSON.parse(hash.to_json)
  end

  private

  def extract_xml
    if pdf_document.attached?
      PdfBlobToXmlJob.perform_now(self)
    end
  end
end
