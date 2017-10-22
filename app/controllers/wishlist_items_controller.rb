class WishlistItemsController < ApplicationController
  before_action :set_wishlist_item, only: [:edit, :update, :destroy]

  def index
    skip_authorization
    @wishlist_items = WishlistItem.includes(:item, :wishlist).priority_order
  end

  def create
    wishlist = Wishlist.find(params[:wishlist_id])
    authorize wishlist.wishlist_items.build

    @wishlist_item = wishlist.wishlist_items.create!(wishlist_item_create_params)
    redirect_to wishlist_path(@wishlist_item.wishlist), notice: "Added #{@wishlist_item.name}."
  end

  def edit
    authorize @wishlist_item
  end

  def update
    authorize @wishlist_item

    if @wishlist_item.update(wishlist_item_params)
      redirect_to @wishlist_item.wishlist, notice: 'Wishlist item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @wishlist_item

    wishlist = @wishlist_item.wishlist
    @wishlist_item.destroy

    redirect_to wishlist, notice: 'Item was successfully removed from wishlist.'
  end

  private
    def set_wishlist_item
      @wishlist_item = WishlistItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wishlist_item_params
      params.require(:wishlist_item).permit(:quantity, :priority, :staff_message)
    end

    def wishlist_item_create_params
      amazon_item = Item.find_or_create_by_asin!(amazon_item_params)
      wishlist_item_params.merge(item: amazon_item)
    end

    def amazon_item_params
      {
        asin:         params[:asin],
        amazon_url:   params[:amazon_url],
        price_cents:  params[:price_cents],
        image_url:    params[:image_url],
        image_width:  params[:image_width],
        image_height: params[:image_height],
        name:         params[:name],
      }
    end
end
