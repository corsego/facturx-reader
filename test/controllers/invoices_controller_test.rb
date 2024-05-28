require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get invoices_url
    assert_response :success
  end

  test "should show invoice" do
    @invoice = invoices(:one)
    get invoice_url(@invoice)
    assert_response :success
  end
end
