# frozen_string_literal: true

# == Schema Information
#
# Table name: wishlists
#
#  id         :integer          not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :wishlist do
    sequence :name { |n| "Wishlist ##{n}" }

    trait :with_item do
      transient do
        item_name 'Item on Wishlist'

        after(:create) do |wishlist, evaluator|
          wishlist.items << create(:item, name: evaluator.item_name)
        end
      end
    end
  end
end
