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
#  site_manager   :boolean
#

FactoryGirl.define do
  factory :user do
    sequence :email { |n| "user#{n}@example.com" }

    factory :admin do
      admin true
    end

    factory :user_with_sites do
      transient do
        site_count 1
      end

      after(:create) do |user, evaluator|
        evaluator.site_count.times do
          user.site_managers.create! wishlist: create(:wishlist)
        end
      end
    end
  end
end
