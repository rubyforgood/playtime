require "amazon_product_api/http_client"

describe AmazonProductAPI::HTTPClient do
  let(:client) {
    env = {
      "AWS_ACCESS_KEY" => "aws_access_key",
      "AWS_SECRET_KEY" => "aws_secret_key",
      "AWS_ASSOCIATES_TAG" => "aws_associates_tag",
    }
    AmazonProductAPI::HTTPClient.new(query: "corgi", page_num: 5, env: env)
  }

  context "when credentials are not present" do
    it "throws an error" do
      expect { AmazonProductAPI::HTTPClient.new(query: "anything", env: {}) }
        .to raise_error(AmazonProductAPI::InvalidQueryError,
          "Environment variables AWS_ACCESS_KEY, AWS_SECRET_KEY, and " +
          "AWS_ASSOCIATES_TAG are required values. Please make sure they're set."
        )
    end
  end

  describe "#env" do
    before {
      allow(ENV).to receive(:[]).with("AWS_ACCESS_KEY") { "" }
      allow(ENV).to receive(:[]).with("AWS_SECRET_KEY") { "" }
      allow(ENV).to receive(:[]).with("AWS_ASSOCIATES_TAG") { "" }
    }
    subject { AmazonProductAPI::HTTPClient.new(query: "anything").env }

    it "defaults to the ENV object" do
      expect(subject).to be ENV
    end
  end

  describe "#url" do
    subject(:url) { client.url }

    it { should start_with "http://webservices.amazon.com/onca/xml" }
    it { should include "AWSAccessKeyId=aws_access_key" }
    it { should include "AssociateTag=aws_associates_tag" }
    it { should include "ItemPage=5" }
    it { should include "Keywords=corgi" }
    it { should include "Operation=ItemSearch" }
    it { should include "ResponseGroup=ItemAttributes%2COffers%2CImages" }
    it { should include "SearchIndex=All" }
    it { should include "Service=AWSECommerceService" }
    it { should include "Timestamp=" }
    it { should include "Signature=" }

    # Edge cases

    context "when no query term was provided" do
      it "should raise an InvalidQueryError" do
        client.query = nil
        expect { client.url }.to raise_error AmazonProductAPI::InvalidQueryError
      end
    end

    context "when no page number was provided" do
      it "should default to page 1" do
        client = AmazonProductAPI::HTTPClient.new(query: "corgi")
        expect(client.url).to include "ItemPage=1"
      end
    end

    context "when the page number is set to nil" do
      it "should raise an InvalidQueryError" do
        client.page_num = nil
        expect { client.url }.to raise_error AmazonProductAPI::InvalidQueryError
      end
    end
  end

  describe "#get" do
    let(:http_double) { double("http") }

    it "should make a `get` request to the specified http library" do
      expect(http_double).to receive(:get).with(String)
      client.get(http: http_double)
    end
  end

  describe "#search_response", :external do
    subject { AmazonProductAPI::HTTPClient.new(query: "corgi").search_response }
    it { should be_a AmazonProductAPI::SearchResponse }
    it { should respond_to :items }
  end
end
