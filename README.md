### App features

- import PDF files
- generate Invoice objects with attached PDF files
- parse PDF files to extract XML
- parse XML to get required data

### Theoretical notes

PDF/A-3: PDF with embedded XML - human and machine readable

match incoming invoice with purchase order => pay

The CEN (European Committee for Standardization) has done this and produced the European Semantic Standard for electronic invoicing (EN 16931).

SIREN FR = NIP PL

credit note VS invoice?

"The presence of a specific PDF/A XMP extension scheme to describe the document as a Factur-X invoice corresponding to this specification, as well as the corresponding XMP metadata."

5.3. 2 differences in the use of Factur-X between France and Germany

6.2.2 ideally data relationship type should be `Alternative` (XML is the alternative to PDF)

The invoice might be not the only file embedded in the PDF!

### Useful links

- https://xrechnungsgenerator.nortal.com/
- https://github.com/itplr-kosit/xrechnung-testsuite
- https://www.ferd-net.de/standards/zugferd-2.2/zugferd-2.2.html?acceptCookie=1
- https://github.com/excid3/receipts
