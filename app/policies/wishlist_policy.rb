# frozen_string_literal: true

class WishlistPolicy < ApplicationPolicy
  def initialize(user, wishlist)
    @user = user
    @wishlist = wishlist
  end

  def show?
    true
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  private

  attr_reader :user, :wishlist
end
