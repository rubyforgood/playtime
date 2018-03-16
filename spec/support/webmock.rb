# frozen_string_literal: true

require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each, :external) do
    # Item Search
    search_response = file_fixture('amazon_corgi_search_response.xml').read
    stub_request(:get, 'webservices.amazon.com/onca/xml')
      .with(query: hash_including('Operation' => 'ItemSearch',
                                  'Keywords'  => 'corgi'))
      .to_return(body: search_response)

    # Item Lookup
    lookup_response = file_fixture('amazon_corgi_lookup_response.xml').read
    stub_request(:get, 'webservices.amazon.com/onca/xml')
      .with(query: hash_including('Operation' => 'ItemLookup',
                                  'ItemId' => 'corgi_asin'))
      .to_return(body: lookup_response)

    stub_request(:get, 'webservices.amazon.com/onca/xml')
      .with(query: hash_including('Keywords' => 'return an error'))
      .to_return(status: 500)
  end
end
