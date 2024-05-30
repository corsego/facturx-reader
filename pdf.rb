# Extracts embedded files from a PDF document.
require 'hexapdf'
require 'debug'

# Open the PDF document
# file_path = 'db/fixtures/factur-x/BASIC/BASIC_Einfach.pdf'
pdf = HexaPDF::Document.open('db/fixtures/factur-x/BASIC/BASIC_Einfach.pdf')

# Get the catalog dictionary which holds the names dictionary
catalog = pdf.catalog

# Extract embedded files from the names dictionary
if catalog.key?(:Names) && catalog[:Names].key?(:EmbeddedFiles)
  embedded_files_tree = catalog[:Names][:EmbeddedFiles]
  embedded_files = embedded_files_tree.value[:Names]

  # Iterate over the embedded files
  embedded_files.each_slice(2) do |name, ref|
    file_spec = pdf.object(ref)
    file_stream = file_spec[:EF][:F]
    file_name = file_spec[:UF] ? file_spec[:UF].to_s : name

    # Write the file to the local file system
    File.binwrite(file_name, file_stream.stream)

    puts "Extracted file: #{file_name}"
  end
else
  puts 'No embedded files found in the PDF.'
end
