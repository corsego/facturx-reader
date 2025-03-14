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
    assert_equal '235.62', due_payable_amount
    assert_equal '235.62', invoice.due_payable_amount
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
    assert_equal '2000.00', due_payable_amount
    assert_equal '2000.00', invoice.due_payable_amount
    assert_equal '2018-10-31T00:00:00+00:00', invoice.invoice_date.to_s
    assert_equal '47110818', invoice.invoice_number
    assert_equal invoice.sender[:name].strip, 'Global Supplies Ltd.'
    assert_equal invoice.sender[:vat], 'GB999999999'
    assert_equal invoice.recipient[:name], 'Metallbau Leipzig GmbH & Co. KG'
    assert_equal invoice.recipient[:vat], 'DE123456789'
    assert_equal invoice.invoice_currency_code, 'EUR'
  end

  test 'xml_document_to_json EXTENDED_Fremdwaehrung.pdf' do
    invoice = Invoice.create
    file_path = 'db/fixtures/factur-x/EXTENDED/EXTENDED_Fremdwaehrung.pdf'
    invoice.pdf_document.attach(io: File.open(file_path), filename: 'EXTENDED_Fremdwaehrung.pdf')
    PdfBlobToXmlJob.perform_now(invoice)

    assert_equal invoice.invoice_currency_code, 'GBP'
    assert_equal invoice.sender[:vat], 'DE123456789'
  end

  test 'import xml document directly' do
    file_path = 'db/fixtures/xml/EXTENDED_Fremdwaehrung.xml'
    invoice = Invoice.create(xml_document: File.read(file_path))
    assert_equal invoice.invoice_currency_code, 'GBP'

    assert invoice.invoice_number.present?
    assert invoice.reload.xml_valid
  end

  test 'import xml document directly with invalid xml' do
    file_path = 'db/fixtures/xml/EXTENDED_Fremdwaehrung_invalid.xml'
    invoice = Invoice.create(xml_document: File.read(file_path))
    assert_nil invoice.invoice_number
    assert_not invoice.reload.xml_valid
  end

  test 'xml_document_to_json XRECHNUNG_Elektron.pdf' do
    invoice = Invoice.create
    file_path = 'db/fixtures/factur-x/XRECHNUNG/XRECHNUNG_Elektron.pdf'
    invoice.pdf_document.attach(io: File.open(file_path), filename: 'XRECHNUNG_Elektron.pdf')
    PdfBlobToXmlJob.perform_now(invoice)

    assert_equal invoice.sender[:vat], ["201/113/40209", "DE123456789"]
  end
end
# rubocop:enable Layout/LineLength
