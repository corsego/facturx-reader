# all the methods related to factur-x documents are defined here
module XmlDocumentConcern
  extend ActiveSupport::Concern

  def xml_document_to_json
    return '' if xml_document.nil?

    parser = Nori.new
    hash = parser.parse(xml_document)
    hash.to_json
    JSON.parse(hash.to_json)
  end

  def due_payable_amount
    xml_document_to_json.dig('rsm:CrossIndustryInvoice', 'rsm:SupplyChainTradeTransaction', 'ram:ApplicableHeaderTradeSettlement', 'ram:SpecifiedTradeSettlementHeaderMonetarySummation', 'ram:DuePayableAmount')
  end
end
