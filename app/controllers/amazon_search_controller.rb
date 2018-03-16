# frozen_string_literal: true

require 'amazon_product_api'
require 'nested_wishlist_context'

class AmazonSearchController < ApplicationController
  before_action :set_wishlist
  before_action :filter_search, only: [:show]

  def show
    authorize :amazon_search, :show?
    @response = amazon_search_response
    redirect_to new_wishlist_amazon_search_path(params[:wishlist_id]), notice: 'Could not connect to Amazon. Please try again later or contact the website adminitrator.' if @response.error?
  end

  def new
    authorize :amazon_search, :new?
  end

  private

  def amazon_search_response
    client = AmazonProductAPI::HTTPClient.new
    query  = client.item_search(query: params[:query],
                                page: params[:page_num] || 1)
    query.response
  end

  def set_wishlist
    @wishlist = Wishlist.find(params[:wishlist_id])
  end

  def pundit_user
    NestedWishlistContext.new(current_user, @wishlist)
  end

  def filter_search
    params[:query].blank? && redirect_to(new_wishlist_amazon_search_path,
                                         notice: "query can't be blank")
  end
end
