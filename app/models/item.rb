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

class Item < ApplicationRecord
  has_many :wishlist_items
  has_many :wishlists, through: :wishlist_items
  attr_accessor :quantity
end
