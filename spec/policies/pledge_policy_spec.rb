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

    it "grants access to anyone (if anonymous)" do
      expect(subject).to permit(GuestUser.new, create(:anonymous_pledge))
    end

    it "denies access to unrelated users (if owned)" do
      expect(subject).not_to permit(build(:user), create(:pledge))
    end

    it "grants access to the pledging user" do
      pledge = create(:pledge)
      expect(subject).to permit(pledge.user, pledge)
    end

    it "grants access to admins" do
      expect(subject).to permit(build(:admin), create(:pledge))
    end
  end

  permissions :create? do
    it "grants access to guests" do
      expect(subject).to permit(GuestUser.new, Pledge)
    end

    it "grants access to users" do
      expect(subject).to permit(build(:user), Pledge)
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

    it "grants access to the pledging user" do
      pledge = create(:pledge)
      expect(subject).to permit(pledge.user, pledge)
    end

    it "grants access to admins" do
      expect(subject).to permit(build(:admin), build(:pledge))
    end
  end

  permissions :destroy? do
    it "denies access to guests" do
      expect(subject).not_to permit(GuestUser.new, build(:pledge))
    end

    it "grants access to anyone (if anonymous)" do
      expect(subject).to permit(GuestUser.new, create(:anonymous_pledge))
    end

    it "denies access to unrelated users (if owned)" do
      expect(subject).not_to permit(build(:user), build(:pledge))
    end

    it "grants access to the pledging user" do
      pledge = create(:pledge)
      expect(subject).to permit(pledge.user, pledge)
    end

    it "grants access to admins" do
      expect(subject).to permit(build(:admin), build(:pledge))
    end
  end
end
