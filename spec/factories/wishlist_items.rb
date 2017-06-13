# == Schema Information
#
# Table name: wishlist_items
#
#  id            :integer          not null, primary key
#  quantity      :integer
#  priority      :string
#  wishlist_id   :integer
#  item_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  staff_message :text
#

FactoryGirl.define do
  factory :wishlist_item do
    wishlist
    item
  end
end
