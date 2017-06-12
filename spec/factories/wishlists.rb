# == Schema Information
#
# Table name: wishlists
#
#  id         :integer          not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :wishlist do
    sequence :name { |n| "Wishlist ##{n}" }
  end
end
