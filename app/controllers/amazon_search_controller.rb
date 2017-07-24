require "amazon_product_api"

class AmazonSearchController < ApplicationController
  skip_before_action :authenticate_admin
  before_action :authenticate_site_manager

  def show
    @response = amazon_client.search_response
  end

  def new
  end

  private
    def amazon_client
      AmazonProductAPI::HTTPClient.new(query: params[:query],
                                       page_num: params[:page_num] || 1)
    end
end
