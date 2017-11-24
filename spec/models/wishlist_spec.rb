# frozen_string_literal: true

# == Schema Information
#
# Table name: wishlists
#
#  id         :integer          not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Wishlist do
  describe 'without a name' do
    subject { build(:wishlist, name: nil) }
    it { should_not be_valid }
  end

  describe 'with a duplicated name' do
    before { create(:wishlist, name: 'Mirage') }
    subject { build(:wishlist, name: 'Mirage') }
    it { should_not be_valid }
  end
end
