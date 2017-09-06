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

  describe ".increment_or_new" do
    let(:params) {
      attributes_for(:pledge).merge(
        # attributes_for doesn't include associations
        user_id: create(:user).id,
        wishlist_item_id: create(:wishlist_item).id
      )
    }

    context "when identical pledge doesn't exist" do
      it "should build a new pledge" do
        pledge = Pledge.increment_or_new(params)
        expect(pledge).to be_new_record
      end
    end

    context "when identical pledge does exist" do
      before { create(:pledge, params) }
      it "should fetch an existing record" do
        pledge = Pledge.increment_or_new(params)
        expect(pledge).to be_persisted
      end

      it "should increment the existing pledge quantity" do
        pledge = Pledge.increment_or_new(params)
        expect(pledge).to be_quantity_changed
        expect(pledge.quantity).to eq 2
      end
    end
  end
end
