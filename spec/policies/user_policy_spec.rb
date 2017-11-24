# frozen_string_literal: true

require 'rails_helper'

describe UserPolicy do
  subject { described_class }

  permissions :index? do
    it 'denies access to guests' do
      expect(subject).not_to permit(GuestUser.new, User)
    end

    it 'denies access to users' do
      expect(subject).not_to permit(build(:user), User)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), User)
    end
  end

  permissions :show? do
    it 'denies access to guests' do
      expect(subject).not_to permit(GuestUser.new, create(:user))
    end

    it 'denies access to users' do
      expect(subject).not_to permit(build(:user), create(:user))
    end

    it 'grants access to the given user' do
      user = create(:user)
      expect(subject).to permit(user, user)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), create(:user))
    end
  end

  permissions :update? do
    it 'denies access to guests' do
      expect(subject).not_to permit(GuestUser.new, build(:user))
    end

    it 'denies access to users' do
      expect(subject).not_to permit(build(:user), build(:user))
    end

    it 'grants access to the given user' do
      user = build(:user)
      expect(subject).to permit(user, user)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), build(:user))
    end
  end

  permissions :destroy? do
    it 'denies access to guests' do
      expect(subject).not_to permit(GuestUser.new, build(:user))
    end

    it 'denies access to users' do
      expect(subject).not_to permit(build(:user), build(:user))
    end

    it 'grants access to the given user' do
      user = build(:user)
      expect(subject).to permit(user, user)
    end

    it 'grants access to admins' do
      expect(subject).to permit(build(:admin), build(:user))
    end
  end

  describe 'permitted_attributes' do
    context 'when the user is an admin' do
      subject do
        UserPolicy.new(build(:admin), build(:user))
                  .permitted_attributes
      end

      it 'includes :admin' do
        expect(subject).to include(:admin)
      end
    end

    context 'when the user is not an admin' do
      subject do
        user = build(:user)
        UserPolicy.new(user, user)
                  .permitted_attributes
      end

      it 'equals only :name and :email' do
        expect(subject).to eq(%i[name email])
      end
    end
  end
end
