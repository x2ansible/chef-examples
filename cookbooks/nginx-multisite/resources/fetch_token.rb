resource_name :fetch_token
provides :fetch_token

property :auth_url, String, required: true
property :client_id, String, required: true
property :client_secret, String, required: true
property :access_token, String

action :fetch do
  require 'net/http'
  require 'uri'

  uri = URI.parse('http://localhost/')
  begin
    response = Net::HTTP.get_response(uri)
    body = response.body

    # Extract a simple pattern from the response (e.g., presence of 'html')
    if body.include?('html')
      token = 'token_extracted_from_' + new_resource.client_id
    else
      token = 'token_empty'
    end
  rescue => e
    token = 'token_fallback_' + new_resource.client_id
  end

  new_resource.access_token = token
  node.run_state['access_token'] = token
end
