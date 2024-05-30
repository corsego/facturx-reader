require "test_helper"

class PdfToXmlJobTest < ActiveJob::TestCase
  # try importing all the files from subfolders within db/fixtures/factur-x
  test "BASIC_Einfach" do
    file_path = 'db/fixtures/factur-x/BASIC/BASIC_Einfach.pdf'
    PdfToXmlJob.perform_now(file_path)

    assert File.exist?('db/fixtures/xml/BASIC_Einfach.xml')
    File.delete('db/fixtures/xml/BASIC_Einfach.xml')
  end

  test "BASIC_Rechnungskorrektur" do
    file_path = 'db/fixtures/factur-x/BASIC/BASIC_Rechnungskorrektur.pdf'
    PdfToXmlJob.perform_now(file_path)

    assert File.exist?('db/fixtures/xml/BASIC_Rechnungskorrektur.xml')
    File.delete('db/fixtures/xml/BASIC_Rechnungskorrektur.xml')
  end
end