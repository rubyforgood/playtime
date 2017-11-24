# frozen_string_literal: true

require 'rails_helper'

describe WishlistPolicy do
  subject { described_class }

  permissions :show? do
    it 'grants access to all' do
      expect(subject).to permit(nil, Wishlist)
    end
  end

  permissions :new? do
    it 'denies access to guests' do
      expect(subject).not_to permit(GuestUser.new, Wishlist)
    end

    it 'denies access to users' do
      expect(subject).not_to permit(build(:user), Wishlist)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), Wishlist)
    end
  end

  permissions :edit? do
    let(:wishlist) { create(:wishlist) }

    it 'denies access to guests' do
      expect(subject).not_to permit(GuestUser.new, wishlist)
    end

    it 'denies access to normal users' do
      expect(subject).not_to permit(build(:user), wishlist)
    end

    it 'denies access to site managers' do
      site_manager = create(:user, wishlists: [wishlist])
      expect(subject).not_to permit(site_manager, wishlist)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), wishlist)
    end
  end

  permissions :create? do
    it 'denies access to guests' do
      expect(subject).not_to permit(GuestUser.new, Wishlist)
    end

    it 'denies access to users' do
      expect(subject).not_to permit(build(:user), Wishlist)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), Wishlist)
    end
  end

  permissions :update? do
    let(:wishlist) { create(:wishlist) }

    it 'denies access to guests' do
      expect(subject).not_to permit(GuestUser.new, wishlist)
    end

    it 'denies access to normal users' do
      expect(subject).not_to permit(build(:user), wishlist)
    end

    it 'denies access to site managers' do
      site_manager = create(:user, wishlists: [wishlist])
      expect(subject).not_to permit(site_manager, wishlist)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), wishlist)
    end
  end

  permissions :destroy? do
    let(:wishlist) { create(:wishlist) }

    it 'denies access to guests' do
      expect(subject).not_to permit(GuestUser.new, wishlist)
    end

    it 'denies access to normal users' do
      expect(subject).not_to permit(build(:user), wishlist)
    end

    it 'denies access to site managers' do
      site_manager = create(:user, wishlists: [wishlist])
      expect(subject).not_to permit(site_manager, wishlist)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), wishlist)
    end
  end
end
