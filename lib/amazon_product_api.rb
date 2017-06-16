module AWSAPIs
  class SearchResponse
    def initialize(hash)
      @hash = hash
    end

    def num_pages
      (hash.dig("ItemSearchResponse", "Items", "TotalPages") || "1").to_i
    end

    def items(item_class: SearchItem)
      item_hashes.map { |attrs| item_class.new(attrs) }
    end

    private

    attr_reader :hash

    def item_hashes
      hash.dig("ItemSearchResponse", "Items", "Item") || []
    end
  end

  class SearchItem
    attr_reader :hash
    def initialize(hash)
      @hash = hash
    end

    def asin
      hash["ASIN"]
    end

    def price_cents
      hash.dig("ItemAttributes", "ListPrice", "Amount").to_i
    end

    def associates_url
      detail_page_url
    end

    def price
      if hash["OfferSummary"].present?
        hash.dig("OfferSummary", "LowestNewPrice", "FormattedPrice")
      else
        '$0.00'
      end
    end

    def small_image_url
      hash.dig("SmallImage", "URL")
    rescue
      ""
    end

    def small_image_width
      hash.dig("SmallImage", "Width") || ""
    end

    def small_image_height
      hash.dig("SmallImage", "Height") || ""
    end

    def title
      hash.dig("ItemAttributes", "Title")
    end

    def detail_page_url
      hash["DetailPageURL"]
    end
  end
end
