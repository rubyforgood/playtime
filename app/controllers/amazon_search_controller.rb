require "amazon_product_api"
require "nested_wishlist_context"

class AmazonSearchController < ApplicationController
  before_action :set_wishlist
  before_action :filter_search, only: [:show]

  def show
    authorize :amazon_search, :show?
    @response = amazon_client.search_response
  end

  def new
    authorize :amazon_search, :new?
  end

  private
    def amazon_client
      AmazonProductAPI::HTTPClient.new(query: params[:query],
                                       page_num: params[:page_num] || 1)
    end

    def set_wishlist
      @wishlist = Wishlist.find(params[:wishlist_id])
    end

    def pundit_user
      NestedWishlistContext.new(current_user, @wishlist)
    end

    def filter_search
      if params[:query].blank?
        redirect_to new_wishlist_amazon_search_path, notice: "query can't be blank"
      end
    end
end
