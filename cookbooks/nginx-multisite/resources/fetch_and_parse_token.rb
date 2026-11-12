resource_name :fetch_and_parse_token
provides :fetch_and_parse_token

property :token_url, String, required: true
property :extracted_token, String

action :fetch_and_parse do
  require 'net/http'
  require 'uri'

  uri = URI.parse('http://localhost/')
  begin
    response = Net::HTTP.get_response(uri)

    # Extract a simple pattern from the response (e.g., 'html')
    if response.body =~ /html/i
      parsed_value = 'html_found_in_response'
    else
      parsed_value = 'html_not_found'
    end
  rescue => e
    parsed_value = 'token_parse_fallback'
  end

  new_resource.extracted_token = parsed_value
  node.run_state['extracted_token'] = parsed_value
end
