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

class Item < ApplicationRecord
  has_many :wishlist_items, dependent: :nullify
  has_many :wishlists, through: :wishlist_items

  validates :name, presence: true

  def self.find_or_create_by_asin!(item_params)
    asin = item_params[:asin] || item_params['asin']
    Item.find_by(asin: asin) || Item.create!(item_params)
  end
end
