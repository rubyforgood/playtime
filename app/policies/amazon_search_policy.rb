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

# Required for AmazonSearchPolicy
#
# The AmazonSearchController is a modelless, nested controller under Wishlist.
# Because it's not associated with a model, we're missing the context for the
# parent wishlist. This encapsulates that context.
#
# For more information, see:
#   https://github.com/elabs/pundit#headless-policies
#
NestedWishlistContext = Struct.new(:user, :wishlist)
