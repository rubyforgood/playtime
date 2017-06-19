require "webmock/rspec"

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each, :external) do
    search_response = file_fixture("amazon_corgi_search_response.xml").read

    stub_request(:get, "webservices.amazon.com/onca/xml")
      .with(query: hash_including("Keywords" => "corgi"))
      .to_return(body: search_response)
  end
end
