# frozen_string_literal: true

require 'amazon_product_api/search_item'

describe AmazonProductAPI::SearchItem do
  describe '#valid?' do
    context 'when all attributes are valid' do
      subject { AmazonProductAPI::SearchItem.new } # minimal valid state
      it { should be_valid }
    end

    context 'when the price is $0.00' do
      subject { AmazonProductAPI::SearchItem.new(price: '$0.00') }
      it { should_not be_valid }
    end
  end

  describe '#valid_image?' do
    it 'returns true for valid data' do
      item = AmazonProductAPI::SearchItem.new(image_url: 'image url',
                                              image_height: 600,
                                              image_width: 800)
      expect(item.valid_image?).to eq true
    end

    it 'returns false for invalid data' do
      item = AmazonProductAPI::SearchItem.new(image_url: nil,
                                              image_height: 600,
                                              image_width: 800)
      expect(item.valid_image?).to eq false
    end
  end
end
