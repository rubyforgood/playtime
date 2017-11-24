# frozen_string_literal: true

require 'rails_helper'

describe PledgePolicy do
  subject { described_class }

  permissions :index? do
    it 'denies access to guests' do
      expect(subject).not_to permit(GuestUser.new, Pledge)
    end

    it 'denies access to users' do
      expect(subject).not_to permit(build(:user), Pledge)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), Pledge)
    end
  end

  permissions :show? do
    it 'grants access to anyone (if anonymous)' do
      expect(subject).to permit(GuestUser.new, create(:pledge, user: nil))
    end

    it 'denies access to guests (if owned)' do
      expect(subject).not_to permit(GuestUser.new, create(:pledge, :with_user))
    end

    it 'denies access to unrelated users (if owned)' do
      expect(subject).not_to permit(build(:user), create(:pledge, :with_user))
    end

    it 'grants access to the pledging user' do
      pledge = create(:pledge, :with_user)
      expect(subject).to permit(pledge.user, pledge)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), create(:pledge, :with_user))
    end
  end

  permissions :create? do
    it 'grants access to guests' do
      expect(subject).to permit(GuestUser.new, Pledge)
    end

    it 'grants access to users' do
      expect(subject).to permit(build(:user), Pledge)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), Pledge)
    end
  end

  permissions :update? do
    it 'grants access to anyone (if anonymous)' do
      expect(subject).to permit(GuestUser.new, build(:pledge, user: nil))
    end

    it 'denies access to guests (if owned)' do
      expect(subject).not_to permit(GuestUser.new, build(:pledge, :with_user))
    end

    it 'denies access to users (if owned)' do
      expect(subject).not_to permit(build(:user), build(:pledge, :with_user))
    end

    it 'grants access to the pledging user' do
      pledge = create(:pledge, :with_user)
      expect(subject).to permit(pledge.user, pledge)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), build(:pledge, :with_user))
    end
  end

  permissions :claim? do
    it 'denies access to guests' do
      expect(subject).not_to permit(GuestUser.new, build(:pledge))
    end

    it 'grants access to users (if anonymous)' do
      expect(subject).to permit(build(:user), create(:pledge, user: nil))
    end

    it 'denies access to users (if owned)' do
      expect(subject).not_to permit(build(:user), build(:pledge, :with_user))
    end
  end

  permissions :destroy? do
    it 'denies access to guests (if owned)' do
      expect(subject).not_to permit(GuestUser.new, build(:pledge, :with_user))
    end

    it 'grants access to anyone (if anonymous)' do
      expect(subject).to permit(GuestUser.new, build(:pledge, user: nil))
    end

    it 'denies access to unrelated users (if owned)' do
      expect(subject).not_to permit(build(:user), build(:pledge, :with_user))
    end

    it 'grants access to the pledging user' do
      pledge = create(:pledge, :with_user)
      expect(subject).to permit(pledge.user, pledge)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), build(:pledge, :with_user))
    end
  end
end
