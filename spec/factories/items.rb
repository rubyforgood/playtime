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

FactoryBot.define do
  factory :item do
    name 'Louis the Corgi'

    trait :on_a_wishlist do
      transient do
        wishlist nil
      end

      after(:create) do |item, evaluator|
        item.wishlists << evaluator.wishlist
      end
    end
  end
end
