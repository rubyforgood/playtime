# == Schema Information
#
# Table name: wishlist_items
#
#  id            :integer          not null, primary key
#  quantity      :integer
#  wishlist_id   :integer
#  item_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  staff_message :text
#  priority      :integer          default("low"), not null
#

describe WishlistItem do
  describe "without an associated wishlist" do
    subject { build(:wishlist_item, wishlist: nil) }
    it { should_not be_valid }
  end

  describe "without an associated item" do
    subject { build(:wishlist_item, item: nil) }
    it { should_not be_valid }
  end

  describe "without a priority" do
    subject { build(:wishlist_item, priority: nil) }
    it { should_not be_valid }
  end

  describe ".active" do
    before {
      create(:wishlist_item, priority: :high)
      create(:wishlist_item, priority: :low)
      create(:wishlist_item, priority: :inactive)
    }

    it "should not return inactive wishlist items" do
      expect(WishlistItem.active.pluck(:priority)).not_to include "inactive"
    end

    it "should include all active wishlist items" do
      expect(WishlistItem.active.count).to eq 2
    end
  end
end
