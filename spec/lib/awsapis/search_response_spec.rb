require "amazon_product_api"

describe AWSAPIs::SearchResponse do
  let(:response_hash) do
    {
      "ItemSearchResponse" => {
        "Items" => {
          "TotalPages" => "5",
          "Item" => ["Item 1", "Item 2", "Item 3"]
        }
      }
    }
  end
  let(:blank_response) { AWSAPIs::SearchResponse.new({}) }
  let(:full_response)  { AWSAPIs::SearchResponse.new(response_hash) }

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

      it "should contain the correct number of items" do
        expect(items.length).to eq 3
      end
    end
  end
end
