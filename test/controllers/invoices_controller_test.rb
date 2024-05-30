require 'test_helper'

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get invoices_url
    assert_response :success
  end

  test 'should show invoice' do
    @invoice = Invoice.create
    get invoice_url(@invoice)
    assert_response :success
  end

  test 'should import invoices' do
    file_path_1 =  'db/fixtures/factur-x/BASIC/BASIC_Einfach.pdf'
    file_path_2 =  'db/fixtures/factur-x/BASIC/BASIC_Rechnungskorrektur.pdf'
    file_1 = fixture_file_upload(file_path_1, 'application/pdf')
    file_2 = fixture_file_upload(file_path_2, 'application/pdf')

    post import_invoices_url, params: { files: [file_1, file_2] }
    assert_redirected_to invoices_url

    assert_equal 2, Invoice.count
    assert Invoice.last.pdf_document.attached?
  end
end
