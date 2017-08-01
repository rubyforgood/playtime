# == Schema Information
#
# Table name: wishlist_items
#
#  id            :integer          not null, primary key
#  quantity      :integer          default(0), not null
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

  describe "without a quantity" do
    subject { build(:wishlist_item, quantity: nil) }
    it { should_not be_valid }
  end

  describe "with a negative quantity" do
    subject { build(:wishlist_item, quantity: -10) }
    it { should_not be_valid }
  end
end
