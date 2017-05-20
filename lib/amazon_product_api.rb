module AWSAPIs
  class SearchResponse
    attr_reader :hash

    def initialize(hash)
      @hash = hash
    end

    def num_pages
      hash["ItemSearchResponse"]["OperationRequest"]["Items"]["TotalPages"] || "1"
    end

    def next_page_link
      hash["ItemSearchResponse"]["OperationRequest"]["Items"]["MoreSearchResultsUrl"]
    end

    def items
      hash["ItemSearchResponse"]["Items"]["Item"].map { |h| Item.new(h) }
    end
  end

  class Item
    attr_reader :hash
    def initialize(hash)
      @hash = hash
    end

    def price
      if hash["OfferSummary"].present?
        hash["OfferSummary"]["LowestNewPrice"]["FormattedPrice"]
      else
        '$0.00'
      end
    end

    def small_image_url
      hash["SmallImage"]["URL"]
    end

    def small_image_width
      hash["SmallImage"]["Width"]
    end

    def small_image_height
      hash["SmallImage"]["Width"]
    end

    def title
      hash["ItemAttributes"]["Title"]
    end

    def detail_page_url
      hash["DetailPageURL"]
    end
  end

  class AmazonProductAPI
    require 'httparty'
    require 'time'
    require 'uri'
    require 'openssl'
    require 'base64'

    AWS_ACCESS_KEY = ENV["AWS_ACCESS_KEY"]
    AWS_SECRET_KEY = ENV["AWS_SECRET_KEY"]
    AWS_ASSOCIATES_TAG = ENV["AWS_ASSOCIATES_TAG"]

    # The region you are interested in
    ENDPOINT = "webservices.amazon.com"

    REQUEST_URI = "/onca/xml"

    def self.params
      params = {
        "Service" => "AWSECommerceService",
        "Operation" => "ItemSearch",
        "AWSAccessKeyId" => ENV["AWS_ACCESS_KEY"],
        "AssociateTag" => ENV["AWS_ASSOCIATES_TAG"],
        "SearchIndex" => "All",
        "Keywords" => "#{@query}",
        "ResponseGroup" => "ItemAttributes,Offers,Images"
      }

      # Set current timestamp if not set
      params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")
      return params
    end

    # Generate the canonical query
    def self.canonical_query_string
      params.sort.collect do |key, value|
        [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")), URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
      end.join('&')
    end

    # Generate the string to be signed
    def self.string_to_sign
      "GET\n#{ENDPOINT}\n#{REQUEST_URI}\n#{canonical_query_string}"
    end

    # Generate the signature required by the Product Advertising API
    def self.signature
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), AWS_SECRET_KEY, string_to_sign)).strip()
    end

    # Generate the signed URL
    def self.search(query)
      @query = query
      url = "http://#{ENDPOINT}#{REQUEST_URI}?#{canonical_query_string}&Signature=#{URI.escape(signature, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"
      HTTParty.get(url)
    end
  end
end
