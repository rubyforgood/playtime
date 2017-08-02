# == Schema Information
#
# Table name: pledges
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  wishlist_item_id :integer
#

require "rails_helper"

describe Pledge do
  describe "without an associated wishlist item" do
    subject { build(:pledge, wishlist_item: nil) }
    it { should_not be_valid }
  end

  describe "without an associated user" do
    subject { build(:pledge, user: nil) }
    it { should_not be_valid }
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
