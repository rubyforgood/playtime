# frozen_string_literal: true

require 'amazon_product_api/item_search_endpoint'

describe AmazonProductAPI::ItemSearchEndpoint do
  AWSTestCredentials = Struct.new(:access_key, :secret_key, :associate_tag)

  let(:aws_credentials) do
    AWSTestCredentials.new('aws_access_key',
                           'aws_secret_key',
                           'aws_associates_tag')
  end
  let(:query) do
    AmazonProductAPI::ItemSearchEndpoint.new('corgi', 5, aws_credentials)
  end

  describe '#url' do
    subject(:url) { query.url }

    it { should start_with 'http://webservices.amazon.com/onca/xml' }
    it { should include 'AWSAccessKeyId=aws_access_key' }
    it { should include 'AssociateTag=aws_associates_tag' }
    it { should include 'ItemPage=5' }
    it { should include 'Keywords=corgi' }
    it { should include 'Operation=ItemSearch' }
    it { should include 'ResponseGroup=ItemAttributes%2COffers%2CImages' }
    it { should include 'SearchIndex=All' }
    it { should include 'Service=AWSECommerceService' }
    it { should include 'Timestamp=' }
    it { should include 'Signature=' }
  end

  describe '#get' do
    let(:http_double) { double('http') }

    it 'should make a `get` request to the specified http library' do
      expect(http_double).to receive(:get).with(String)
      query.get(http: http_double)
    end
  end

  describe '#response', :external do
    subject do
      query = AmazonProductAPI::ItemSearchEndpoint.new('corgi', 1,
                                                       aws_credentials)
      query.response
    end
    it { should respond_to :items }
  end
end
