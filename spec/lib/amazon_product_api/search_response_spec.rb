# frozen_string_literal: true

require 'amazon_product_api/search_response'

describe AmazonProductAPI::SearchResponse do
  let(:response_hash) do
    {
      'ItemSearchResponse' => {
        'Items' => {
          'TotalPages' => '5',
          'Item' => [{}, {}, {}]
        }
      }
    }
  end
  let(:blank_response) { AmazonProductAPI::SearchResponse.new({}, 200) }
  let(:full_response)  { AmazonProductAPI::SearchResponse.new(response_hash, 200) }
  let(:success_codes) { [200, 204, 302, 304] }
  let(:failure_codes) { [400, 500] }

  describe '#num_pages' do
    context 'no page number is present' do
      subject { blank_response.num_pages }
      it { should eq 1 }
    end

    context 'a page number is present' do
      subject { full_response.num_pages }
      it { should eq 5 }
    end
  end

  describe '#items' do
    let(:mock_item_class) { double('Item', new: 'New item!') }

    context 'when there are no returned items' do
      subject { blank_response.items }
      it { should eq [] }
    end

    context 'when items are returned' do
      subject(:items) { full_response.items(item_class: mock_item_class) }

      it 'should create the correct number of new items' do
        expect(mock_item_class).to receive(:new).exactly(3).times
        items
      end
    end
  end

  describe '#success' do
    context 'a successfull response' do
      it 'should return true for success codes' do
        success_codes.each do |code|
          response = AmazonProductAPI::SearchResponse.new({}, code)
          expect(response.success?).to be(true), "expected true, got #{response.success?} for code #{code}"
        end
      end

      it 'should return false for non-success codes' do
        failure_codes.each do |code|
          response = AmazonProductAPI::SearchResponse.new({}, code)
          expect(response.success?).to be(false), "expected false, got #{response.success?} for code #{code}"
        end
      end
    end
  end

  describe '#error' do
    context 'a successfull response' do
      it 'should return false for success codes' do
        success_codes.each do |code|
          response = AmazonProductAPI::SearchResponse.new({}, code)
          expect(response.error?).to be(false), "expected false, got #{response.success?} for code #{code}"
        end
      end

      it 'should return true for non-success codes' do
        failure_codes.each do |code|
          response = AmazonProductAPI::SearchResponse.new({}, code)
          expect(response.error?).to be(true), "expected true, got #{response.success?} for code #{code}"
        end
      end
    end
  end
end
