# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  name           :text
#  email          :text             not null
#  admin          :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  amazon_user_id :string
#  zipcode        :string
#

FactoryBot.define do
  factory :user do
    sequence :email { |n| "user#{n}@example.com" }

    factory :admin do
      admin true
    end

    trait :with_sites do
      transient do
        site_count 1
      end

      after(:create) do |user, evaluator|
        evaluator.site_count.times do
          user.wishlists << create(:wishlist)
        end
      end
    end
  end
end
