require "test_helper"

class InvoiceTest < ActiveSupport::TestCase
  test "xml_document_to_json BASIC_Einfach.pdf" do
    invoice = Invoice.create
    file_path = 'db/fixtures/factur-x/BASIC/BASIC_Einfach.pdf'
    invoice.pdf_document.attach(io: File.open(file_path), filename: 'BASIC_Einfach.pdf')
    PdfBlobToXmlJob.perform_now(invoice)

    assert_match "<?xml version=", invoice.xml_document
    due_payable_amount = invoice.xml_document_to_json.dig('rsm:CrossIndustryInvoice', 'rsm:SupplyChainTradeTransaction', 'ram:ApplicableHeaderTradeSettlement', 'ram:SpecifiedTradeSettlementHeaderMonetarySummation', 'ram:DuePayableAmount')
    assert_match "235.62", due_payable_amount
    assert_match "235.62", invoice.due_payable_amount
  end

  test "xml_document_to_json EXTENDED_InnergemeinschLieferungMehrereBestellungen.pdf" do
    invoice = Invoice.create
    file_path = 'db/fixtures/factur-x/EXTENDED/EXTENDED_InnergemeinschLieferungMehrereBestellungen.pdf'
    invoice.pdf_document.attach(io: File.open(file_path), filename: 'EXTENDED_InnergemeinschLieferungMehrereBestellungen.pdf')
    PdfBlobToXmlJob.perform_now(invoice)

    assert_match "<?xml version=", invoice.xml_document
    due_payable_amount = invoice.xml_document_to_json.dig('rsm:CrossIndustryInvoice', 'rsm:SupplyChainTradeTransaction', 'ram:ApplicableHeaderTradeSettlement', 'ram:SpecifiedTradeSettlementHeaderMonetarySummation', 'ram:DuePayableAmount')
    assert_match "2000.00", due_payable_amount
    assert_match "2000.00", invoice.due_payable_amount
  end
end
