class WishlistItemsController < ApplicationController
  def index
    @wishlist_items = WishlistItem.build_index
  end
end
