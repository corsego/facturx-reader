require 'test_helper'

# rubocop:disable Layout/LineLength
class InvoiceTest < ActiveSupport::TestCase
  test 'xml_document_to_json BASIC_Einfach.pdf' do
    invoice = Invoice.create
    file_path = 'db/fixtures/factur-x/BASIC/BASIC_Einfach.pdf'
    invoice.pdf_document.attach(io: File.open(file_path), filename: 'BASIC_Einfach.pdf')
    PdfBlobToXmlJob.perform_now(invoice)

    assert_match '<?xml version=', invoice.xml_document
    due_payable_amount = invoice.xml_document_to_json.dig('rsm:CrossIndustryInvoice',
                                                          'rsm:SupplyChainTradeTransaction', 'ram:ApplicableHeaderTradeSettlement', 'ram:SpecifiedTradeSettlementHeaderMonetarySummation', 'ram:DuePayableAmount')
    assert_match '235.62', due_payable_amount
    assert_match '235.62', invoice.due_payable_amount
  end

  test 'xml_document_to_json EXTENDED_InnergemeinschLieferungMehrereBestellungen.pdf' do
    invoice = Invoice.create
    file_path = 'db/fixtures/factur-x/EXTENDED/EXTENDED_InnergemeinschLieferungMehrereBestellungen.pdf'
    invoice.pdf_document.attach(io: File.open(file_path),
                                filename: 'EXTENDED_InnergemeinschLieferungMehrereBestellungen.pdf')
    PdfBlobToXmlJob.perform_now(invoice)

    assert_match '<?xml version=', invoice.xml_document
    due_payable_amount = invoice.xml_document_to_json.dig('rsm:CrossIndustryInvoice',
                                                          'rsm:SupplyChainTradeTransaction', 'ram:ApplicableHeaderTradeSettlement', 'ram:SpecifiedTradeSettlementHeaderMonetarySummation', 'ram:DuePayableAmount')
    assert_match '2000.00', due_payable_amount
    assert_match '2000.00', invoice.due_payable_amount
    assert_match '2018-10-31T00:00:00+00:00', invoice.invoice_date.to_s
    assert_match '47110818', invoice.invoice_number
    assert_match invoice.sender[:name].strip, 'Global Supplies Ltd.'
    assert_match invoice.sender[:vat], 'GB999999999'
    assert_match invoice.recipient[:name], 'Metallbau Leipzig GmbH & Co. KG'
    assert_match invoice.recipient[:vat], 'DE123456789'
    assert_match invoice.invoice_currency_code, 'EUR'
  end

  test 'xml_document_to_json EXTENDED_Fremdwaehrung.pdf' do
    invoice = Invoice.create
    file_path = 'db/fixtures/factur-x/EXTENDED/EXTENDED_Fremdwaehrung.pdf'
    invoice.pdf_document.attach(io: File.open(file_path), filename: 'EXTENDED_Fremdwaehrung.pdf')
    PdfBlobToXmlJob.perform_now(invoice)

    assert_match invoice.invoice_currency_code, 'GBP'
  end

  test "import xml document directly" do
    file_path = 'db/fixtures/xml/EXTENDED_Fremdwaehrung.xml'
    invoice = Invoice.create(xml_document: File.read(file_path))
    assert_equal invoice.invoice_currency_code, 'GBP'
  end
end
# rubocop:enable Layout/LineLength
