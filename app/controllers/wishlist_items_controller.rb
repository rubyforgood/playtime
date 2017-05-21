class WishlistItemsController < ApplicationController
  def index
    @wishlist_items = WishlistItem.build_index
  end

  def create
    @wishlist = Wishlist.find(params[:wishlist_id])
    @item =
      Item.find_by_asin(params[:asin]) ||
      Item.create!(
        asin: params[:asin],
        amazon_url: params[:amazon_url],
        price_cents: params[:price_cents],
        image_url: params[:image_url],
        image_width: params[:image_width],
        image_height: params[:image_height],
        name: params[:name])
    @wishlist_item = @wishlist.wishlist_items.create!(
      item: @item,
      quantity: params[:qty],
      staff_message: params[:staff_message])

    redirect_to wishlist_path(@wishlist), notice: "Added #{@item.name}"
  end

end
