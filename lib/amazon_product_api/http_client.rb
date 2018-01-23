# frozen_string_literal: true

require 'amazon_product_api/item_search_endpoint'
require 'amazon_product_api/item_lookup_endpoint'

module AmazonProductAPI
  # Responsible for managing all Amazon Product API queries.
  #
  # All endpoints (returning query objects) should live in this class.
  class HTTPClient
    attr_reader :env # injectable credentials

    def initialize(env: ENV)
      @env = env
      assign_env_vars
    end

    def item_search(query:, page: 1)
      ItemSearchEndpoint.new(query, page, aws_credentials)
    end

    def item_lookup(asin)
      ItemLookupEndpoint.new(asin, aws_credentials)
    end

    private

    attr_reader :aws_credentials

    # rubocop:disable UnneededDisable, Blank
    def assign_env_vars
      @aws_credentials = AWSCredentials.new(env['AWS_ACCESS_KEY'],
                                            env['AWS_SECRET_KEY'],
                                            env['AWS_ASSOCIATES_TAG'])
      msg = 'Environment variables AWS_ACCESS_KEY, AWS_SECRET_KEY, and ' \
              'AWS_ASSOCIATES_TAG are required values. Please make sure ' \
              'they\'re set.'
      raise InvalidQueryError, msg unless @aws_credentials.present?
    end
    # rubocop:enable UnneededDisable, Blank
  end

  # Wrapper object to store/verify AWS credentials
  AWSCredentials = Struct.new(:access_key, :secret_key, :associate_tag) do
    def present?
      access_key && secret_key && associate_tag
    end
  end

  class InvalidQueryError < StandardError; end
end
