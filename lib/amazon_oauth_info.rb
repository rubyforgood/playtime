# frozen_string_literal: true

class AmazonOAuthInfo
  attr_reader :hash

  def initialize(hash)
    @hash = hash
  end

  def amazon_user_id
    hash['uid']
  end

  def email
    hash['info']['email']
  end

  def name
    hash['info']['name']
  end

  def zipcode
    hash['extra']['postal_code']
  end
end
