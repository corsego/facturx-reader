# extract embedded files from a PDF document
# only files that are named `factur-x.xml` or `xrechnung.xml` are extracted
class PdfBlobToXmlJob < ApplicationJob
  queue_as :default

  VALID_FILENAME = %w[factur-x.xml xrechnung.xml].freeze

  def perform(invoice)
    return unless invoice.pdf_document.blob.content_type == 'application/pdf'

    tempfile = Tempfile.new
    tempfile.binmode
    tempfile.write(invoice.pdf_document.download)
    tempfile.rewind

    # binding.b
    begin
      pdf = HexaPDF::Document.open(tempfile.path)
    rescue HexaPDF::Error
      invoice.update(xml_valid: false)
    end
    return unless pdf

    catalog = pdf.catalog

    if catalog.key?(:Names) && catalog[:Names].key?(:EmbeddedFiles)
      embedded_files_tree = catalog[:Names][:EmbeddedFiles]
      embedded_files = embedded_files_tree.value[:Names]

      embedded_files.each_slice(2) do |name, ref|
        file_spec = pdf.object(ref)
        file_stream = file_spec[:EF][:F]
        file_name = file_spec[:UF] ? file_spec[:UF].to_s : name

        next unless VALID_FILENAME.include?(file_name)

        invoice.update(xml_document: file_stream.stream.force_encoding('UTF-8'))
        invoice.update(xml_valid: true)

        puts "Extracted file: #{file_name}"
      end
    else
      puts 'No embedded files found in the PDF.'
    end

    invoice.update(xml_valid: false) unless invoice.xml_valid?
  ensure
    tempfile.close
    tempfile.unlink
  end
end
