require "amazon_product_api/search_response"

describe AmazonProductAPI::SearchResponse do
  let(:response_hash) do
    {
      "ItemSearchResponse" => {
        "Items" => {
          "TotalPages" => "5",
          "Item" => [{}, {}, {}]
        }
      }
    }
  end
  let(:blank_response) { AmazonProductAPI::SearchResponse.new({}) }
  let(:full_response)  { AmazonProductAPI::SearchResponse.new(response_hash) }

  describe "#num_pages" do
    context "no page number is present" do
      subject { blank_response.num_pages }
      it { should eq 1 }
    end

    context "a page number is present" do
      subject { full_response.num_pages }
      it { should eq 5 }
    end
  end

  describe "#items" do
    let(:mock_item_class) { double("Item", new: "New item!") }

    context "when there are no returned items" do
      subject { blank_response.items }
      it { should eq [] }
    end

    context "when items are returned" do
      subject(:items) { full_response.items(item_class: mock_item_class) }

      it "should create the correct number of new items" do
        expect(mock_item_class).to receive(:new).exactly(3).times
        items
      end
    end
  end
end
