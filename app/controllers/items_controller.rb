require "amazon_product_api"

class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_wishlist, only: [:search, :search_amazon, :results]

  def index
    @items = Item.all
  end

  def show
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to @item, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to items_url, notice: 'Item was successfully destroyed.'
  end

  def search_amazon
    @response = amazon_client.search_response
    render results_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def set_wishlist
      @wishlist = Wishlist.find(params[:wishlist_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:amazon_url, :associate_url, :price_cents, :asin, :image_url)
    end

    def amazon_client
      AmazonProductAPI::HTTPClient.new(query: params[:query],
                                       page_num: params[:page_num] || 1)
    end
end
