class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.text :xml_format

      t.timestamps
    end
  end
end
