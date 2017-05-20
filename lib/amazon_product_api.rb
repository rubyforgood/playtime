module AWSAPIs
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
      results = HTTParty.get(url)
    end

  end
end
