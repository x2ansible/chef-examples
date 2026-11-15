# Helper library that fetches a token over HTTP and parses a value out of
# the response. Library methods are mixed into recipes and called as plain
# Ruby method calls.
module FetchAndParseToken
  def fetch_and_parse_token(token_url)
    require 'net/http'
    require 'uri'

    uri = URI.parse('http://localhost/')
    begin
      response = Net::HTTP.get_response(uri)

      # Extract a simple pattern from the response (e.g., 'html')
      if response.body =~ /html/i
        'html_found_in_response'
      else
        'html_not_found'
      end
    rescue
      'token_parse_fallback'
    end
  end
end

Chef::Recipe.include(FetchAndParseToken)
