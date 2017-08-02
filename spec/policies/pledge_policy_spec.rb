require 'rails_helper'

describe PledgePolicy do
  subject { described_class }

  permissions :index? do
    it "denies access to guests" do
      expect(subject).not_to permit(GuestUser.new, Pledge)
    end

    it "denies access to users" do
      expect(subject).not_to permit(build(:user), Pledge)
    end

    it "grants access to admins" do
      expect(subject).to permit(build(:admin), Pledge)
    end
  end

  permissions :show? do
    it "denies access to guests" do
      expect(subject).not_to permit(GuestUser.new, create(:pledge))
    end

    it "denies access to users" do
      expect(subject).not_to permit(build(:user), create(:pledge))
    end

    it "grants access to admins" do
      expect(subject).to permit(build(:admin), create(:pledge))
    end
  end

  permissions :create? do
    it "denies access to guests" do
      expect(subject).not_to permit(GuestUser.new, Pledge)
    end

    it "denies access to users" do
      expect(subject).not_to permit(build(:user), Pledge)
    end

    it "grants access to admins" do
      expect(subject).to permit(build(:admin), Pledge)
    end
  end

  permissions :update? do
    it "denies access to guests" do
      expect(subject).not_to permit(GuestUser.new, build(:pledge))
    end

    it "denies access to users" do
      expect(subject).not_to permit(build(:user), build(:pledge))
    end

    it "grants access to admins" do
      expect(subject).to permit(build(:admin), build(:pledge))
    end
  end

  permissions :destroy? do
    it "denies access to guests" do
      expect(subject).not_to permit(GuestUser.new, build(:pledge))
    end

    it "denies access to users" do
      expect(subject).not_to permit(build(:user), build(:pledge))
    end

    it "grants access to admins" do
      expect(subject).to permit(build(:admin), build(:pledge))
    end
  end
end
