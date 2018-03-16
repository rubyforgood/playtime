# frozen_string_literal: true

require 'amazon_product_api/search_response'

module AmazonProductAPI
  # Responsible for building and executing an Amazon Product API search query.
  #
  # http://docs.aws.amazon.com/AWSECommerceService/latest/DG/ItemSearch.html
  #
  # Any logic relating to searching, building the query string, authentication
  # signatures, etc. should live in this class.
  class ItemSearchEndpoint
    require 'httparty'
    require 'time'
    require 'uri'
    require 'openssl'
    require 'base64'

    # The region you are interested in
    ENDPOINT = 'webservices.amazon.com'
    REQUEST_URI = '/onca/xml'

    attr_accessor :query, :page, :aws_credentials

    def initialize(query, page, aws_credentials)
      @query = query
      @page = page
      @aws_credentials = aws_credentials
    end

    # Generate the signed URL
    def url
      raise InvalidQueryError unless query && page

      "http://#{ENDPOINT}#{REQUEST_URI}" +    # base
        "?#{canonical_query_string}" +        # query
        "&Signature=#{uri_escape(signature)}" # signature
    end

    # Send the HTTP request
    def get(http: HTTParty)
      http.get(url)
    end

    # Performs the search query and returns the resulting SearchResponse
    def response(http: HTTParty, logger: Rails.logger)
      response = get(http: http)
      logger.debug response
      SearchResponse.new(parse_response(response), response.code)
    rescue StandardError => e
      Rollbar.error(e, "Failed to connect to Amazon. Reqeust: #{http}")
      SearchResponse.new({}, 500)
    end

    private

    def parse_response(response)
      Hash.from_xml(response.body)
    end

    # Generate the signature required by the Product Advertising API
    def signature
      Base64.encode64(digest_with_key(string_to_sign)).strip
    end

    # Generate the string to be signed
    def string_to_sign
      "GET\n#{ENDPOINT}\n#{REQUEST_URI}\n#{canonical_query_string}"
    end

    # Generate the canonical query
    def canonical_query_string
      params.sort
            .map { |key, value| "#{uri_escape(key)}=#{uri_escape(value)}" }
            .join('&')
    end

    def params
      params = {
        'Service'         => 'AWSECommerceService',
        'AWSAccessKeyId'  => aws_credentials.access_key,
        'AssociateTag'    => aws_credentials.associate_tag,
        # endpoint-specific
        'Operation'       => 'ItemSearch',
        'ResponseGroup'   => 'ItemAttributes,Offers,Images',
        'SearchIndex'     => 'All',
        'Keywords'        => query.to_s,
        'ItemPage'        => page.to_s
      }

      # Set current timestamp if not set
      params['Timestamp'] ||= Time.now.gmtime.iso8601
      params
    end

    def digest_with_key(string)
      OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'),
                           aws_credentials.secret_key,
                           string)
    end

    def uri_escape(phrase)
      CGI.escape(phrase.to_s)
    end
  end
end
