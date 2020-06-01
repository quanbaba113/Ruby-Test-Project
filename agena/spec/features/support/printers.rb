module Printers

  SIMULATORS = {
      'Instant Ink' => 'http://c2t17823.itcs.hpicorp.net/',
      'WPP' => 'http://loadrepo.psr.rd.hpicorp.net/'
  }

  DEFAULT_MODEL = "A9T80A"

  def create_simulated_printer_payload(environment, simulator_url_key)
    fail unless SIMULATORS.key? simulator_url_key
    model = DEFAULT_MODEL
    path = 'PSRestUtils/v/1.0/printer/register'
    headers = { 'Content-Type' => 'application/xml' }
    body = <<-XML
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<registerPrinter>
  <stack>#{environment}</stack>
  <modelName>hp</modelName>
  <modelNumber>#{model}</modelNumber>
  <duration>86400</duration>
  <registerTime>950000</registerTime>
  <owner>gabriel.oliveira</owner>
  <ownerPassword>brazil</ownerPassword>
</registerPrinter>
    XML
    {
      "url" => SIMULATORS[simulator_url_key] + path,
      "body" => body,
      "headers" => headers
    }
  end

  def parse_simulated_printer_response(response)
    xml_doc = Nokogiri::XML.parse(response.body)
    fail if xml_doc.xpath('//registerPrinterResponse').empty? or response.status != 200
    {
        "email" => xml_doc.xpath('//printerEmailId').text,
        "serial_number" => xml_doc.xpath('//serialNumber').text,
        "cloud_identifier" => xml_doc.xpath('//printerId').text
    }
  end
end