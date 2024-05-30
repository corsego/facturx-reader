# all the methods related to factur-x documents are defined here
module FacturxXmlConcern
  extend ActiveSupport::Concern

  def parsed_xml
    Nokogiri::XML(xml_document)
  end

  def iban
    parsed_xml.xpath('//ram:IBANID').text
  end

  def account_name
    parsed_xml.xpath('//ram:AccountName').text
  end
end
