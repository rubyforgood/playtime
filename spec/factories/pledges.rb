# frozen_string_literal: true

# == Schema Information
#
# Table name: pledges
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  wishlist_item_id :integer
#  quantity         :integer          default(1), not null
#

FactoryBot.define do
  factory :pledge do
    wishlist_item

    trait :with_user do
      user
    end
  end
end
