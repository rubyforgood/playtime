# frozen_string_literal: true

require 'amazon_product_api/search_item'

module AmazonProductAPI
  # Parses the Amazon Product API search response
  #
  # Any logic that involves digging through the response hash should live in
  # this class. By isolating it from the rest of the codebase, we only have one
  # file to touch if the API response changes.
  class SearchResponse
    SUCCESS_CODE_RANGE = (200..299)
    FOUND_CODE = 302
    NOT_MODIFIED = 304
    SUCCESS_CODES = SUCCESS_CODE_RANGE.to_a + [FOUND_CODE, NOT_MODIFIED]

    def initialize(response_hash, code)
      @response_hash = response_hash
      @code = code
    end

    def num_pages
      (response_hash.dig('ItemSearchResponse', 'Items', 'TotalPages') || 1).to_i
    end

    def items(item_class: SearchItem)
      item_hashes.map { |hash| item_class.new(**item_attrs_from(hash)) }
    end

    def success?
      SUCCESS_CODES.include?(code)
    end

    def error?
      !success?
    end

    private

    attr_reader :response_hash, :code

    def item_attrs_from(hash)
      {
        asin: hash['ASIN'],

        price_cents: hash.dig('ItemAttributes', 'ListPrice', 'Amount').to_i,
        price: hash.dig('OfferSummary', 'LowestNewPrice', 'FormattedPrice') || '$0.00',

        image_url:    hash.dig('SmallImage', 'URL') || '',
        image_width:  hash.dig('SmallImage', 'Width') || '',
        image_height: hash.dig('SmallImage', 'Height') || '',

        title:              hash.dig('ItemAttributes', 'Title'),
        detail_page_url:    hash['DetailPageURL']
      }
    end

    def item_hashes
      response_hash.dig('ItemSearchResponse', 'Items', 'Item') || []
    end
  end
end
