# all the methods related to factur-x documents are defined here
# rubocop:disable Layout/LineLength
module FacturxJsonConcern
  extend ActiveSupport::Concern

  def xml_document_to_json
    return '' if xml_document.nil?

    parser = Nori.new
    hash = parser.parse(xml_document)
    hash.to_json
    JSON.parse(hash.to_json)
  end

  # sum total
  def due_payable_amount
    xml_document_to_json.dig('rsm:CrossIndustryInvoice', 'rsm:SupplyChainTradeTransaction', 'ram:ApplicableHeaderTradeSettlement', 'ram:SpecifiedTradeSettlementHeaderMonetarySummation', 'ram:DuePayableAmount')
  end

  def invoice_date
    DateTime.parse xml_document_to_json.dig('rsm:CrossIndustryInvoice', 'rsm:ExchangedDocument', 'ram:IssueDateTime', 'udt:DateTimeString')
  end
  
  def invoice_number
    xml_document_to_json.dig('rsm:CrossIndustryInvoice', 'rsm:ExchangedDocument', 'ram:ID')
  end
  
  def sender
    { name: xml_document_to_json.dig('rsm:CrossIndustryInvoice', 'rsm:SupplyChainTradeTransaction', 'ram:ApplicableHeaderTradeAgreement', 'ram:SellerTradeParty', 'ram:Name'),
      vat: xml_document_to_json.dig('rsm:CrossIndustryInvoice', 'rsm:SupplyChainTradeTransaction', 'ram:ApplicableHeaderTradeAgreement', 'ram:SellerTradeParty', 'ram:SpecifiedTaxRegistration', 'ram:ID')
    }
  end
  
  def recipient
    { name: xml_document_to_json.dig('rsm:CrossIndustryInvoice', 'rsm:SupplyChainTradeTransaction', 'ram:ApplicableHeaderTradeAgreement', 'ram:BuyerTradeParty', 'ram:Name'),
      vat: xml_document_to_json.dig('rsm:CrossIndustryInvoice', 'rsm:SupplyChainTradeTransaction', 'ram:ApplicableHeaderTradeAgreement', 'ram:BuyerTradeParty', 'ram:SpecifiedTaxRegistration', 'ram:ID')
    }
  end
  
  def line_items
    xml_document_to_json.dig('rsm:CrossIndustryInvoice', 'rsm:SupplyChainTradeTransaction', 'ram:IncludedSupplyChainTradeLineItem')
  end
  
  # "sub-sums" (the totals for each tax-type (0%, 7% and 19%))
  def tax_totals
    line_items = xml_document_to_json.dig('rsm:CrossIndustryInvoice', 'rsm:SupplyChainTradeTransaction', 'ram:IncludedSupplyChainTradeLineItem')
    totals = Hash.new(0)
    line_items.each do |item|
      tax_rate = item.dig('ram:SpecifiedLineTradeSettlement', 'ram:ApplicableTradeTax', 'ram:RateApplicablePercent').to_f
      total_amount = item.dig('ram:SpecifiedLineTradeSettlement', 'ram:SpecifiedTradeSettlementLineMonetarySummation', 'ram:LineTotalAmount').to_f
      totals[tax_rate] += total_amount
    end
    totals
  end
end
# rubocop:enable Layout/LineLength
