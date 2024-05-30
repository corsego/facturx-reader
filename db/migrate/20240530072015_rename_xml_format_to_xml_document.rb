class RenameXmlFormatToXmlDocument < ActiveRecord::Migration[7.1]
  def change
    rename_column :invoices, :xml_format, :xml_document
  end
end
