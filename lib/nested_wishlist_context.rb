# frozen_string_literal: true

# Required for AmazonSearchPolicy
#
# The AmazonSearchController is a modelless, nested controller under Wishlist.
# Because it's not associated with a model, we're missing the context for the
# parent wishlist. This encapsulates that context.
#
# For more information, see:
#   https://github.com/elabs/pundit#headless-policies
#

class NestedWishlistContext
  def initialize(user, wishlist)
    @user = user
    @wishlist = wishlist
  end

  attr_reader :user, :wishlist
end
