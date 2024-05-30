class AddValidXmlToInvoice < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :xml_valid, :boolean
  end
end
