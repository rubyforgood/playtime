# frozen_string_literal: true

# == Schema Information
#
# Table name: wishlist_items
#
#  id            :integer          not null, primary key
#  quantity      :integer          default(0), not null
#  wishlist_id   :integer
#  item_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  staff_message :text
#  priority      :integer          default("low"), not null
#

FactoryBot.define do
  factory :wishlist_item do
    wishlist
    item
    quantity 1
  end
end
