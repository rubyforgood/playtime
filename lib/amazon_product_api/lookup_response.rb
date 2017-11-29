# frozen_string_literal: true

require 'amazon_product_api/search_item'

module AmazonProductAPI
  # Parses the Amazon Product API item lookup response
  #
  # Any logic that involves digging through the response hash should live in
  # this class. By isolating it from the rest of the codebase, we only have one
  # file to touch if the API response changes.
  class LookupResponse
    def initialize(response_hash)
      @hash = item_hash_for response_hash
    end

    def item(item_class: SearchItem)
      item_class.new(**item_attrs)
    end

    private

    attr_reader :hash

    def item_attrs
      {
        asin: hash['ASIN'],

        price_cents: hash.dig('ItemAttributes', 'ListPrice', 'Amount').to_i,

        image_url:    hash.dig('SmallImage', 'URL') || '',
        image_width:  hash.dig('SmallImage', 'Width') || '',
        image_height: hash.dig('SmallImage', 'Height') || '',

        title:              hash.dig('ItemAttributes', 'Title'),
        detail_page_url:    hash['DetailPageURL']
      }
    end

    def item_hash_for(response_hash)
      response_hash.dig('ItemLookupResponse', 'Items', 'Item') || []
    end
  end
end
