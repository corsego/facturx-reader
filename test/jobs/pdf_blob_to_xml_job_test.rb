require "test_helper"

class PdfBlobToXmlJobTest < ActiveJob::TestCase
  # try importing all the files from subfolders within db/fixtures/factur-x
  test "BASIC_Einfach" do
    invoice = Invoice.create
    file_path = 'db/fixtures/factur-x/BASIC/BASIC_Einfach.pdf'
    invoice.pdf_document.attach(io: File.open(file_path), filename: 'BASIC_Einfach.pdf')
    PdfBlobToXmlJob.perform_now(invoice)

    assert_match "<?xml version=", invoice.xml_document
    assert invoice.xml_valid
  end

  test "BASIC_Rechnungskorrektur" do
    invoice = Invoice.create
    file_path = 'db/fixtures/factur-x/BASIC/BASIC_Rechnungskorrektur.pdf'
    invoice.pdf_document.attach(io: File.open(file_path), filename: 'BASIC_Rechnungskorrektur.pdf')
    PdfBlobToXmlJob.perform_now(invoice)

    assert_match "<?xml version=", invoice.xml_document
    assert invoice.xml_valid
  end

  test 'invalid file' do
    invoice = Invoice.create
    file = Tempfile.new(['invalid', '.pdf'])
    invoice.pdf_document.attach(io: File.open(file), filename: 'invalid.pdf')
    PdfBlobToXmlJob.perform_now(invoice)

    assert_nil invoice.xml_document
    refute invoice.xml_valid
  end
end
