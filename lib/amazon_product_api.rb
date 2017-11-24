# frozen_string_literal: true

require 'amazon_product_api/http_client'

module AmazonProductAPI
  # Contains all code for interacting with the Amazon Product API
  #
  # There are two main responsibilities of this module:
  #
  #   * `HTTPClient` is responsible for building and executing the query
  #     to the Amazon Product API. Any logic relating to endpoints, building
  #     the query string, authentication signatures, etc. can be found here.
  #
  #   * `SearchResponse` is responsible for parsing the search response and
  #     creating a list of returned items. Any logic relating to the response
  #     structure can be found here.
end
