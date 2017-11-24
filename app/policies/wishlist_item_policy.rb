# frozen_string_literal: true

class WishlistItemPolicy < ApplicationPolicy
  def initialize(user, wishlist_item)
    @user = user
    @wishlist = wishlist_item.wishlist
  end

  def index?
    true
  end

  def create?
    user.can_manage? wishlist
  end

  def update?
    user.can_manage? wishlist
  end

  def destroy?
    user.can_manage? wishlist
  end

  private

  attr_reader :user, :wishlist
end
