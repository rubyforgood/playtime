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
  end
end
