# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  name           :text
#  email          :text             not null
#  admin          :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  amazon_user_id :string
#  zipcode        :string
#

require 'spec_helper'

describe User do
  # Default Values

  context 'with the default (non-required) attributes' do
    subject { create(:user) }
    it { should_not be_admin }
  end

  # Validations

  context 'without an email' do
    subject { build(:user, email: nil) }
    it { should_not be_valid }
  end

  context 'with a duplicated email' do
    before { create(:user, email: 'dup@example.com') }
    subject { build(:user, email: 'dup@example.com') }
    it { should_not be_valid }
  end

  context 'with a duplicated amazon id' do
    before { create(:user, amazon_user_id: 1) }
    subject { build(:user, amazon_user_id: 1) }
    it { should_not be_valid }
  end

  context 'with (multiple) blank amazon ids' do
    before { create(:user, amazon_user_id: nil) }
    subject { build(:user, amazon_user_id: nil) }
    it { should be_valid }
  end

  # Instance Methods

  describe '#can_manage?' do
    context 'when the user is neither site manager nor admin' do
      subject(:user) { build(:user) }

      it 'cannot manage a wishlist' do
        wishlist = build(:wishlist)
        expect(user.can_manage?(wishlist)).to be false
      end
    end

    describe 'when the user is a site manager' do
      subject(:site_manager) { create(:user, :with_sites) }

      context 'when they own the specified wishlist' do
        let(:their_wishlist) { subject.wishlists.first }
        it 'can manage the wishlist' do
          expect(site_manager.can_manage?(their_wishlist)).to be true
        end
      end

      context "when they don't own the specified wishlist" do
        let(:another_wishlist) { build(:wishlist) }
        it 'cannot manage the wishlist' do
          expect(site_manager.can_manage?(another_wishlist)).to be false
        end
      end
    end

    describe 'when the user is an admin' do
      subject(:admin) { build(:admin) }

      it "can manage any site's wishlist" do
        random_wishlist = build(:wishlist)
        expect(admin.can_manage?(random_wishlist)).to be true
      end
    end
  end

  describe '#display_name' do
    context 'when the user has no associated name' do
      subject { build(:user, name: nil, email: 'foo@bar.biz').display_name }
      it { should eq 'foo@bar.biz' }
    end

    context 'when the user has a name' do
      subject { build(:user, name: 'Sally Ride').display_name }
      it { should eq 'Sally Ride' }
    end
  end

  describe '#logged_in?' do
    subject { build(:user).logged_in? }
    it { should be true }
  end

  describe '#pledge_count' do
    subject do
      user = create(:user, pledges: [create(:pledge, user: nil, quantity: 2),
                                     create(:pledge, user: nil)])
      user.pledge_count
    end
    it { should eq 3 }
  end

  describe '#made_pledge?' do
    let(:pledge) { create(:pledge) }

    context 'when the user made the pledge' do
      subject { build(:user, pledges: [pledge]).pledged?(pledge) }
      it { should be true }
    end

    context "when the user didn't make the pledge" do
      subject do
        other_pledge = create(:pledge, :with_user)
        build(:user, pledges: [other_pledge]).pledged?(pledge)
      end
      it { should be false }
    end
  end

  describe '#pledge_for' do
    let(:user) { create(:user) }
    let(:pledge) { create(:pledge, user: user) }

    context 'when the user pledged the item' do
      subject { user.pledge_for(pledge.wishlist_item) }
      it { should eq pledge }
    end

    context "when the user didn't pledge the item" do
      subject { user.pledge_for(create(:wishlist_item)) }
      it { should be nil }
    end
  end

  # Class Methods

  describe '.find_or_create_by_amazon_hash' do
    subject(:matched_user) { User.find_or_create_from_amazon_hash!(hash) }
    let(:hash) do
      JSON.parse '{
        "uid" : "1",
        "info" : {
          "email" : "jglenn@nasa.gov",
          "name"  : "John Glenn, Jr."
        },
        "extra" : {
          "postal_code" : 54321
        }
      }'
    end

    context 'when the amazon user id matches' do
      let!(:existing_user) { create(:user, amazon_user_id: '1') }

      it 'returns the matching user' do
        expect(existing_user).to eq matched_user
      end

      it 'should not change the number of users' do
        expect { matched_user }.not_to(change { User.count })
      end
    end

    context 'when the email matches' do
      let!(:existing_user) { create(:user, email: 'jglenn@nasa.gov') }

      it 'returns the matching user' do
        expect(existing_user).to eq matched_user
      end

      it 'should not change the number of users' do
        expect { matched_user }.not_to(change { User.count })
      end
    end

    context 'when the user cannot be found' do
      it 'creates a new user' do
        expect { subject }.to change { User.count }.by 1
      end
    end
  end

  describe '.generate_csv' do
    before { create(:user, name: 'Wally Schirra') }
    subject(:csv) { User.generate_csv }

    it 'should generate a csv' do
      expect(csv).to include 'name'
      expect(csv).to include 'Wally Schirra'
    end
  end
end
