# frozen_string_literal: true

require 'amazon_product_api/http_client'

describe AmazonProductAPI::HTTPClient do
  subject(:client) do
    env = {
      'AWS_ACCESS_KEY' => 'aws_access_key',
      'AWS_SECRET_KEY' => 'aws_secret_key',
      'AWS_ASSOCIATES_TAG' => 'aws_associates_tag'
    }

    AmazonProductAPI::HTTPClient.new(env: env)
  end

  context 'when credentials are not present' do
    it 'throws an error' do
      expect { AmazonProductAPI::HTTPClient.new(env: {}) }
        .to raise_error(AmazonProductAPI::InvalidQueryError,
                        'Environment variables AWS_ACCESS_KEY, AWS_SECRET_KEY, and ' \
                        "AWS_ASSOCIATES_TAG are required values. Please make sure they're set.")
    end
  end

  describe '#env' do
    before do
      allow(ENV).to receive(:[]).with('AWS_ACCESS_KEY') { '' }
      allow(ENV).to receive(:[]).with('AWS_SECRET_KEY') { '' }
      allow(ENV).to receive(:[]).with('AWS_ASSOCIATES_TAG') { '' }
    end
    subject { AmazonProductAPI::HTTPClient.new.env }

    it 'defaults to the ENV object' do
      expect(subject).to be ENV
    end
  end

  # Verify the endpoints

  it { is_expected.to respond_to :item_search }
  it { is_expected.to respond_to :item_lookup }

  describe '#item_search' do
    context 'when no query term was provided' do
      it 'should raise an InvalidQueryError' do
        expect { client.item_search }.to raise_error ArgumentError
      end
    end

    context 'when no page number was provided' do
      it 'should default to page 1' do
        generated_url = client.item_search(query: 'anything').url
        expect(generated_url).to include 'ItemPage=1'
      end
    end

    context 'when the page number is set to nil' do
      it 'should raise an InvalidQueryError' do
        expect do
          client.item_search(query: 'anything', page: nil).url
        end.to raise_error AmazonProductAPI::InvalidQueryError
      end
    end
  end
end
