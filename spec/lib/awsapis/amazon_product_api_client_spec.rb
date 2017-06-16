require "amazon_product_api_client"

describe AWSAPIs::AmazonProductAPIClient do
  let(:client) {
    AWSAPIs::AmazonProductAPIClient.new(query: "corgi", page_num: 1)
  }

  describe "#url" do
    subject(:url) { client.url }

    # Check url components (secrets in .env.test)

    it { should start_with "http://webservices.amazon.com/onca/xml" }
    it { should include "AWSAccessKeyId=aws_access_key" }
    it { should include "AssociateTag=aws_associates_tag" }
    it { should include "ItemPage=1" }
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
        expect { client.url }.to raise_error AWSAPIs::InvalidQueryError
      end
    end

    context "when no page number was provided" do
      it "should default to page 1" do
        client = AWSAPIs::AmazonProductAPIClient.new(query: "corgi")
        expect(client.url).to include "ItemPage=1"
      end
    end

    context "when the page number is set to nil" do
      it "should raise an InvalidQueryError" do
        client.page_num = nil
        expect { client.url }.to raise_error AWSAPIs::InvalidQueryError
      end
    end
  end

  describe "#search" do
    let(:http_double) { double("http") }

    it "should make a `get` request to the specified http library" do
      expect(http_double).to receive(:get).with(String)
      client.search(http: http_double)
    end
  end
end
