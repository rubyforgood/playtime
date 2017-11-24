# frozen_string_literal: true

# == Schema Information
#
# Table name: items
#
#  id            :integer          not null, primary key
#  amazon_url    :string
#  associate_url :string
#  price_cents   :integer
#  asin          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  image_url     :string
#  image_height  :integer
#  image_width   :integer
#  name          :text             not null
#

require 'rails_helper'

describe Item do
  describe 'without a name' do
    subject { build(:item, name: nil) }
    it { should_not be_valid }
  end

  describe '.find_or_create_by_asin!' do
    let(:item_params) { attributes_for(:item, asin: 'exists') }

    context 'when an item with that asin exists' do
      before { create(:item, asin: 'exists') }

      it 'should NOT create a new item' do
        expect do
          Item.find_or_create_by_asin!(item_params)
        end.not_to change(Item, :count)
      end

      it 'should return an Item with the given asin' do
        item = Item.find_or_create_by_asin!(item_params)
        expect(item.asin).to eq 'exists'
      end
    end

    context 'when no object with that asin exists' do
      it 'should NOT create a new item' do
        expect do
          Item.find_or_create_by_asin!(item_params)
        end.to change(Item, :count).by(1)
      end

      it 'should return an Item with the given asin' do
        item = Item.find_or_create_by_asin!(item_params)
        expect(item.asin).to eq 'exists'
      end
    end
  end
end
