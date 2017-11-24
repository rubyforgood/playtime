# frozen_string_literal: true

require 'rails_helper'

describe AmazonSearchPolicy do
  subject { described_class }

  permissions :show? do
    it 'denies access to guests' do
      context = NestedWishlistContext.new(GuestUser.new, create(:wishlist))
      expect(subject).not_to permit(context, :amazon_search)
    end

    it 'denies access to users' do
      context = NestedWishlistContext.new(create(:user), create(:wishlist))
      expect(subject).not_to permit(context, :amazon_search)
    end

    it 'denies access to site managers of different sites' do
      context = NestedWishlistContext.new(create(:user, :with_sites),
                                          create(:wishlist))
      expect(subject).not_to permit(context, :amazon_search)
    end

    it 'grants access to site admin of current site' do
      wishlist = create(:wishlist)
      context = NestedWishlistContext.new(create(:user, wishlists: [wishlist]),
                                          wishlist)
      expect(subject).to permit(context, :amazon_search)
    end

    it 'grants access to admins' do
      context = NestedWishlistContext.new(create(:admin), create(:wishlist))
      expect(subject).to permit(context, :amazon_search)
    end
  end

  permissions :new? do
    it 'denies access to guests' do
      context = NestedWishlistContext.new(GuestUser.new, create(:wishlist))
      expect(subject).not_to permit(context, :amazon_search)
    end

    it 'denies access to users' do
      context = NestedWishlistContext.new(create(:user), create(:wishlist))
      expect(subject).not_to permit(context, :amazon_search)
    end

    it 'denies access to site managers of different sites' do
      context = NestedWishlistContext.new(create(:user, :with_sites),
                                          create(:wishlist))
      expect(subject).not_to permit(context, :amazon_search)
    end

    it 'grants access to site admin of current site' do
      wishlist = create(:wishlist)
      context = NestedWishlistContext.new(create(:user, wishlists: [wishlist]),
                                          wishlist)
      expect(subject).to permit(context, :amazon_search)
    end

    it 'grants access to admins' do
      context = NestedWishlistContext.new(create(:admin), create(:wishlist))
      expect(subject).to permit(context, :amazon_search)
    end
  end
end
