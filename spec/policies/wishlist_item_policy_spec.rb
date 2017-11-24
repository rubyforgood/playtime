# frozen_string_literal: true

require 'rails_helper'

describe WishlistItemPolicy do
  let(:wishlist) { create(:wishlist, :with_item) }
  let(:wishlist_item) { wishlist.wishlist_items.first }

  subject { described_class }

  permissions :index? do
    it 'grants access to guests' do
      expect(subject).to permit(GuestUser.new, wishlist_item)
    end
  end

  permissions :create? do
    it 'denies access to guests' do
      expect(subject).not_to permit(GuestUser.new, wishlist_item)
    end

    it 'denies access to normal users' do
      expect(subject).not_to permit(build(:user), wishlist_item)
    end

    it 'denies access to site managers of different wishlists' do
      site_manager = create(:user, :with_sites)
      expect(subject).not_to permit(site_manager, wishlist_item)
    end

    it 'grants access to site managers of the current wishlist' do
      site_manager = create(:user, wishlists: [wishlist])
      expect(subject).to permit(site_manager, wishlist_item)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), wishlist_item)
    end
  end

  permissions :update? do
    it 'denies access to guests' do
      expect(subject).not_to permit(GuestUser.new, wishlist_item)
    end

    it 'denies access to normal users' do
      expect(subject).not_to permit(build(:user), wishlist_item)
    end

    it 'denies access to site managers of different wishlists' do
      site_manager = create(:user, :with_sites)
      expect(subject).not_to permit(site_manager, wishlist_item)
    end

    it 'grants access to site managers of the current wishlist' do
      site_manager = create(:user, wishlists: [wishlist])
      expect(subject).to permit(site_manager, wishlist_item)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), wishlist_item)
    end
  end

  permissions :destroy? do
    it 'denies access to guests' do
      expect(subject).not_to permit(GuestUser.new, wishlist_item)
    end

    it 'denies access to normal users' do
      expect(subject).not_to permit(build(:user), wishlist_item)
    end

    it 'denies access to site managers of different wishlists' do
      site_manager = create(:user, :with_sites)
      expect(subject).not_to permit(site_manager, wishlist_item)
    end

    it 'grants access to site managers of the current wishlist' do
      site_manager = create(:user, wishlists: [wishlist])
      expect(subject).to permit(site_manager, wishlist_item)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), wishlist_item)
    end
  end
end
