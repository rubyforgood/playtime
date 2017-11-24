# frozen_string_literal: true

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

require 'rails_helper'

describe Pledge do
  # validations

  describe 'without an associated wishlist item' do
    subject { build(:pledge, wishlist_item: nil) }
    it { should_not be_valid }
  end

  describe 'without an associated user' do
    subject { build(:pledge, user: nil) }
    it { should be_valid }
  end

  describe 'without a quantity' do
    subject { build(:pledge, quantity: nil) }
    it { should_not be_valid }
  end

  describe 'with a quantity of 0' do
    subject { build(:pledge, quantity: 0) }
    it { should_not be_valid }
  end

  describe 'uniqueness validation' do
    let(:initial_pledge) { create(:pledge, :with_user) }

    context 'when the user and wishlist are duplicated' do
      subject do
        build(:pledge, user: initial_pledge.user,
                       wishlist_item: initial_pledge.wishlist_item)
      end
      it { should_not be_valid }
    end

    context 'when the user is duplicated but not the wishlist' do
      subject { build(:pledge, user: initial_pledge.user) }
      it { should be_valid }
    end

    context 'when the wishlist item is duplicated but not the user' do
      subject { build(:pledge, wishlist_item: initial_pledge.wishlist_item) }
      it { should be_valid }
    end

    context 'when the user is nil' do
      it 'should allow for "duplicate" pledges' do
        wishlist_item = create(:wishlist_item)
        create(:pledge, user: nil, wishlist_item: wishlist_item)
        anon_pledge = build(:pledge, wishlist_item: wishlist_item)

        expect(anon_pledge).to be_valid
      end
    end
  end

  describe '#edited?' do
    let(:pledge) { create(:pledge) }

    context "when it's not been updated" do
      subject { pledge.edited? }
      it { should be false }
    end

    context 'when it has been updated' do
      before { pledge.update!(quantity: 2) }
      subject { pledge.edited? }
      it { should be true }
    end
  end

  describe '#anonymous?' do
    context "when it's owned by a user" do
      subject { create(:pledge, :with_user).anonymous? }
      it { should be false }
    end

    context "when it's not owned by a user" do
      subject { create(:pledge, user: nil).anonymous? }
      it { should be true }
    end
  end

  describe '#claim_or_increment' do
    context 'when another pledge with those attributes exists' do
      let(:user) { create(:user) }
      let(:existing_pledge) { create(:pledge, user: user) }
      let(:pledge) { create(:pledge, user: nil, wishlist_item: existing_pledge.wishlist_item) }

      it 'should belong to user' do
        pledge.claim_or_increment(user_id: user.id)
        expect(pledge.reload.user).to eq user
      end

      it 'should delete the previous pledge' do
        expect do
          pledge.claim_or_increment(user_id: user.id)
        end.to change(Pledge, :count).by(1)
      end

      it 'should increment the quantity' do
        pledge.claim_or_increment(user_id: user.id)
        expect(pledge.reload.quantity).to eq 2
      end
    end

    context "when it's a unique pledge" do
      it 'should belong to the user' do
        user = create(:user)
        pledge = create(:pledge, user: nil)
        pledge.claim_or_increment(user_id: user.id)
        expect(pledge.reload.user).to eq user
      end
    end
  end

  describe '.generate_csv' do
    before { create(:pledge, user: create(:user, name: 'Tony Stark')) }
    subject(:csv) { Pledge.generate_csv }

    it 'should generate a csv' do
      expect(csv).to include 'user,'
      expect(csv).to include 'Tony Stark'
    end
  end

  describe '.increment_or_new' do
    let(:params) do
      attributes_for(:pledge).merge(
        # attributes_for doesn't include associations
        user_id: create(:user).id,
        wishlist_item_id: create(:wishlist_item).id
      )
    end

    context "when identical pledge doesn't exist" do
      it 'should build a new pledge' do
        pledge = Pledge.increment_or_new(params)
        expect(pledge).to be_new_record
      end
    end

    context 'when identical pledge does exist' do
      before { create(:pledge, params) }
      it 'should fetch an existing record' do
        pledge = Pledge.increment_or_new(params)
        expect(pledge).to be_persisted
      end

      it 'should increment the existing pledge quantity' do
        pledge = Pledge.increment_or_new(params)
        expect(pledge).to be_quantity_changed
        expect(pledge.quantity).to eq 2
      end
    end
  end
end
