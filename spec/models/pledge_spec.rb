# == Schema Information
#
# Table name: pledges
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  wishlist_item_id :integer
#  quantity         :integer          default(1), not null
#

require "rails_helper"

describe Pledge do

  # validations

  describe "without an associated wishlist item" do
    subject { build(:pledge, wishlist_item: nil) }
    it { should_not be_valid }
  end

  describe "without an associated user" do
    subject { build(:pledge, user: nil) }
    it { should_not be_valid }
  end

  describe "without a quantity" do
    subject { build(:pledge, quantity: nil) }
    it { should_not be_valid }
  end

  describe "with a quantity of 0" do
    subject { build(:pledge, quantity: 0) }
    it { should_not be_valid }
  end

  describe "uniqueness validation" do
    let(:initial_pledge) { create(:pledge) }

    context "when the user and wishlist are duplicated" do
      subject { build(:pledge, user: initial_pledge.user,
                      wishlist_item: initial_pledge.wishlist_item) }
      it { should_not be_valid }
    end

    context "when the user is duplicated but not the wishlist" do
      subject { build(:pledge, user: initial_pledge.user) }
      it { should be_valid }
    end

    context "when the wishlist item is duplicated but not the user" do
      subject { build(:pledge, wishlist_item: initial_pledge.wishlist_item) }
      it { should be_valid }
    end
  end

  describe ".generate_csv" do
    before { create(:pledge, id: 100) }
    subject(:csv) { Pledge.generate_csv }

    it "should generate a csv" do
      expect(csv).to include "id"
      expect(csv).to include "100"
    end
  end
end
