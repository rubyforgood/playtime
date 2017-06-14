# == Schema Information
#
# Table name: pledges
#
#  id         :integer          not null, primary key
#  item_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Pledge do
  describe "without an associated item" do
    subject { build(:pledge, item: nil) }
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
