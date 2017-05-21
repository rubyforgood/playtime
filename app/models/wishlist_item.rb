class WishlistItem < ApplicationRecord
  belongs_to :wishlist
  belongs_to :item

  delegate :amazon_url, :price_cents, :asin, :image_url, :image_width, :image_height, :name, to: :item

  def self.build_index
    items = WishlistItem.where("priority != 'inactive'").map(&:item)
    items.uniq.map do |item|
      qtys = WishlistItem.where("priority != 'inactive' AND item_id = ?", item.id).map(&:quantity)
      item.quantity = qtys.sum
      item
    end
  end

end
