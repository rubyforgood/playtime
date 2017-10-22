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

class WishlistItem < ApplicationRecord
  belongs_to :wishlist
  belongs_to :item
  has_many :pledges

  delegate :amazon_url, :price_cents, :asin, :name,
           :image_url, :image_width, :image_height,
           to: :item

  enum priority: [:low, :medium, :high]

  validates :priority, presence: true
  validates :quantity, presence: true,
                       numericality: { greater_than_or_equal_to: 0 }

  scope :priority_order, -> { order(priority: :desc) }
end
