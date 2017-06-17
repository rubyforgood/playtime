require "amazon_product_api/search_item"

module AmazonProductAPI
  # Parses the Amazon Product API search response
  #
  # Any logic that involves digging through the response hash should live in
  # this class. By isolating it from the rest of the codebase, we only have one
  # file to touch if the API response changes.
  class SearchResponse
    def initialize(hash)
      @hash = hash
    end

    def num_pages
      (hash.dig("ItemSearchResponse", "Items", "TotalPages") || "1").to_i
    end

    def items(item_class: SearchItem)
      item_hashes.map { |hash| item_class.new **item_attrs_from(hash) }
    end

    private

    attr_reader :hash

    def item_attrs_from(hash)
      {
        asin: hash["ASIN"],

        price_cents: hash.dig("ItemAttributes", "ListPrice", "Amount").to_i,
        price: hash.dig("OfferSummary", "LowestNewPrice", "FormattedPrice") || "$0.00",

        image_url:    hash.dig("SmallImage", "URL") || "",
        image_width:  hash.dig("SmallImage", "Width") || "",
        image_height: hash.dig("SmallImage", "Height") || "",

        title:              hash.dig("ItemAttributes", "Title"),
        detail_page_url:    hash["DetailPageURL"],
      }
    end

    def item_hashes
      hash.dig("ItemSearchResponse", "Items", "Item") || []
    end
  end
end
