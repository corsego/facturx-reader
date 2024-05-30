require "test_helper"

class InvoiceTest < ActiveSupport::TestCase
  test "xml_document_to_json" do
    invoice = Invoice.create
    file_path = 'db/fixtures/factur-x/BASIC/BASIC_Einfach.pdf'
    invoice.pdf_document.attach(io: File.open(file_path), filename: 'BASIC_Einfach.pdf')
    PdfBlobToXmlJob.perform_now(invoice)

    assert_match "<?xml version=", invoice.xml_document
    due_payable_amount = invoice.xml_document_to_json.dig('rsm:CrossIndustryInvoice', 'rsm:SupplyChainTradeTransaction', 'ram:ApplicableHeaderTradeSettlement', 'ram:SpecifiedTradeSettlementHeaderMonetarySummation', 'ram:DuePayableAmount')
    assert_match "235.62", due_payable_amount
  end
end
