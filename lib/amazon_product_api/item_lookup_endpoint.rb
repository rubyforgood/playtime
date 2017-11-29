# frozen_string_literal: true

require 'amazon_product_api/lookup_response'

module AmazonProductAPI
  # Responsible for looking up an item listing on Amazon
  #
  # http://docs.aws.amazon.com/AWSECommerceService/latest/DG/ItemLookup.html
  #
  # Any logic relating to lookup, building the query string, authentication
  # signatures, etc. should live in this class.
  class ItemLookupEndpoint
    require 'httparty'
    require 'time'
    require 'uri'
    require 'openssl'
    require 'base64'

    # The region you are interested in
    ENDPOINT = 'webservices.amazon.com'
    REQUEST_URI = '/onca/xml'

    attr_accessor :asin, :aws_credentials

    def initialize(asin, aws_credentials)
      @asin = asin
      @aws_credentials = aws_credentials
    end

    # Generate the signed URL
    def url
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
      response = parse_response get(http: http)
      logger.debug(response)
      LookupResponse.new(response).item
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
        'Operation'       => 'ItemLookup',
        'ResponseGroup'   => 'ItemAttributes,Offers,Images',
        'ItemId'          => asin.to_s
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
