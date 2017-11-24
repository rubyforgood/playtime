# frozen_string_literal: true

require 'nested_wishlist_context'

class AmazonSearchPolicy
  def initialize(context, amazon_search)
    @user = context.user
    @wishlist = context.wishlist
    @amazon_search = amazon_search
  end

  def show?
    new?
  end

  def new?
    user.can_manage? wishlist
  end

  private

  attr_reader :user, :wishlist, :amazon_search
end
