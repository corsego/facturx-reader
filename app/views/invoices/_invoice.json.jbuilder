json.extract! invoice, :id, :xml_document, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
