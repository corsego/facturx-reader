# extract embedded files from a PDF document
# only files that are named `factur-x.xml` or `xrechnung.xml` are extracted

# file_path = 'db/fixtures/factur-x/BASIC/BASIC_Einfach.pdf'
# file_path = 'db/fixtures/factur-x/EXTENDED/EXTENDED_Fremdwaehrung.pdf'
# PdfToXmlJob.perform_now(file_path)
class PdfToXmlJob < ApplicationJob
  queue_as :default

  VALID_FILENAME = %w[factur-x.xml xrechnung.xml].freeze

  def perform(file_path)
    pdf = HexaPDF::Document.open(file_path)
    catalog = pdf.catalog

    if catalog.key?(:Names) && catalog[:Names].key?(:EmbeddedFiles)
      embedded_files_tree = catalog[:Names][:EmbeddedFiles]
      embedded_files = embedded_files_tree.value[:Names]

      embedded_files.each_slice(2) do |name, ref|
        file_spec = pdf.object(ref)
        file_stream = file_spec[:EF][:F]
        file_name = file_spec[:UF] ? file_spec[:UF].to_s : name

        next unless VALID_FILENAME.include?(file_name)

        new_file = File.basename(file_path).gsub!('.pdf', '.xml')
        File.binwrite("db/fixtures/xml/#{new_file}", file_stream.stream)

        puts "Extracted file: #{new_file}"
      end
    else
      puts 'No embedded files found in the PDF.'
    end
  end
end
