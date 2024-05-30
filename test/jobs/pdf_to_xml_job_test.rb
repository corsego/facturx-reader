require "test_helper"

class PdfToXmlJobTest < ActiveJob::TestCase
  # try importing all the files from subfolders within db/fixtures/factur-x
  test "BASIC_Einfach" do
    invoice = Invoice.create
    file_path = 'db/fixtures/factur-x/BASIC/BASIC_Einfach.pdf'
    invoice.pdf_document.attach(io: File.open(file_path), filename: 'BASIC_Einfach.pdf')
    PdfToXmlJob.perform_now(invoice)

    assert_match "<?xml version=", invoice.xml_document
    assert File.exist?('factur-x.xml')
    File.delete('factur-x.xml')
  end

  test "BASIC_Rechnungskorrektur" do
    invoice = Invoice.create
    file_path = 'db/fixtures/factur-x/BASIC/BASIC_Rechnungskorrektur.pdf'
    invoice.pdf_document.attach(io: File.open(file_path), filename: 'BASIC_Rechnungskorrektur.pdf')
    PdfToXmlJob.perform_now(invoice)

    assert_match "<?xml version=", invoice.xml_document
    assert File.exist?('factur-x.xml')
    File.delete('factur-x.xml')
  end
end
