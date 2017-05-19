class WishlistItem < ApplicationRecord
  belongs_to :wishlist
  belongs_to :item

  def self.build_index
    items = WishlistItems.where(priority: 'active').map(&:item)
    items.map do |item|
      qtys = WishlistItem.where(priority: 'active', item_id: item.id).map(&:quantity)
      item.quantity = qtys.sum
    end
  end

  def index_params
  end
end
