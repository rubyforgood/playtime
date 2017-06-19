require "amazon_product_api/search_response"

module AmazonProductAPI
  # Responsible for building and executing the query to the Amazon Product API.
  #
  # Any logic relating to endpoints, building the query string, authentication
  # signatures, etc. should live in this class.
  class HTTPClient
    require 'httparty'
    require 'time'
    require 'uri'
    require 'openssl'
    require 'base64'

    # Environment config
    AWS_ACCESS_KEY = ENV["AWS_ACCESS_KEY"]
    AWS_SECRET_KEY = ENV["AWS_SECRET_KEY"]
    AWS_ASSOCIATES_TAG = ENV["AWS_ASSOCIATES_TAG"]

    # The region you are interested in
    ENDPOINT = "webservices.amazon.com"
    REQUEST_URI = "/onca/xml"


    attr_writer :query, :page_num

    def initialize(query:, page_num: 1)
      @query = query
      @page_num = page_num
    end

    # Generate the signed URL
    def url
      raise InvalidQueryError unless query && page_num

      "http://#{ENDPOINT}#{REQUEST_URI}" +  # base
      "?#{canonical_query_string}" +        # query
      "&Signature=#{uri_escape(signature)}" # signature
    end

    # Performs the search query and returns the resulting SearchResponse
    def search_response(http: HTTParty)
      response = get(http: http)
      SearchResponse.new parse_response(response)
    end

    # Send the HTTP request
    def get(http: HTTParty)
      http.get(url)
    end


    private


    attr_reader :query, :page_num

    def parse_response(response)
      Hash.from_xml(response.body)
    end

    def uri_escape(phrase)
      URI.escape(phrase.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def params
      params = {
        "Service"         => "AWSECommerceService",
        "Operation"       => "ItemSearch",
        "AWSAccessKeyId"  => AWS_ACCESS_KEY,
        "AssociateTag"    => AWS_ASSOCIATES_TAG,
        "SearchIndex"     => "All",
        "Keywords"        => query.to_s,
        "ResponseGroup"   => "ItemAttributes,Offers,Images",
        "ItemPage"        => page_num.to_s
      }

      # Set current timestamp if not set
      params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")
      params
    end

    # Generate the canonical query
    def canonical_query_string
      params.sort
            .map { |key, value| "#{uri_escape(key)}=#{uri_escape(value)}" }
            .join("&")
    end

    # Generate the string to be signed
    def string_to_sign
      "GET\n#{ENDPOINT}\n#{REQUEST_URI}\n#{canonical_query_string}"
    end

    # Generate the signature required by the Product Advertising API
    def signature
      Base64.encode64(digest_with_key string_to_sign).strip
    end

    def digest_with_key(string)
      OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'),
                           AWS_SECRET_KEY,
                           string)
    end
  end

  class InvalidQueryError < StandardError; end
end
