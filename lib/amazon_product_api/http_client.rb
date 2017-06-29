require "amazon_product_api/search_response"

module AmazonProductAPI
  # Responsible for building and executing the query to the Amazon Product API.
  #
  # Any logic relating to endpoints, building the query string, authentication
  # signatures, etc. should live in this class.
  class HTTPClient
    require "httparty"
    require "time"
    require "uri"
    require "openssl"
    require "base64"

    # The region you are interested in
    ENDPOINT = "webservices.amazon.com"
    REQUEST_URI = "/onca/xml"

    attr_reader :env
    attr_writer :query, :page_num

    def initialize(query:, page_num: 1, env: ENV)
      @query = query
      @page_num = page_num
      @env = env
      assign_env_vars
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


    attr_reader :query, :page_num, :aws_credentials

    def assign_env_vars
      @aws_credentials = AWSCredentials.new(env["AWS_ACCESS_KEY"],
                                            env["AWS_SECRET_KEY"],
                                            env["AWS_ASSOCIATES_TAG"])
      unless aws_credentials.present?
        msg = "Environment variables AWS_ACCESS_KEY, AWS_SECRET_KEY, and " \
              "AWS_ASSOCIATES_TAG are required values. Please make sure " \
              "they're set."
        fail InvalidQueryError, msg
      end
    end

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
        "AWSAccessKeyId"  => aws_credentials.access_key,
        "AssociateTag"    => aws_credentials.associate_tag,
        "SearchIndex"     => "All",
        "Keywords"        => query.to_s,
        "ResponseGroup"   => "ItemAttributes,Offers,Images",
        "ItemPage"        => page_num.to_s
      }

      # Set current timestamp if not set
      params["Timestamp"] ||= Time.now.gmtime.iso8601
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
      OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"),
                           aws_credentials.secret_key,
                           string)
    end
  end

  # Wrapper object to store/verify AWS credentials
  AWSCredentials = Struct.new(:access_key, :secret_key, :associate_tag) do
    def present?
      access_key && secret_key && associate_tag
    end
  end

  class InvalidQueryError < StandardError; end
end
