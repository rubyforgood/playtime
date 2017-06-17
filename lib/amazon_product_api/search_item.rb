module AmazonProductAPI
  # Represents an individual Amazon item listing
  class SearchItem
    attr_reader :asin, :price_cents, :price, :title, :detail_page_url

    def initialize(**attrs)
      @asin = attrs[:asin]
      @title = attrs[:title]
      @price = attrs[:price]
      @price_cents = attrs[:price_cents]
      @detail_page_url = attrs[:detail_page_url]

      @image = WebImage.new(attrs[:image_url],
                            attrs[:image_width],
                            attrs[:image_height])
    end

    def image_url
      image.url
    end

    def image_width
      image.width
    end

    def image_height
      image.height
    end

    alias_method :associates_url, :detail_page_url

    private

    attr_reader :image
  end

  WebImage = Struct.new(:url, :width, :height)
end
