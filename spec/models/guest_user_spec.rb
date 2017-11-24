# frozen_string_literal: true

require 'spec_helper'

describe GuestUser do
  let(:guest) { GuestUser.new }

  describe 'admin?' do
    subject { guest.admin? }
    it { should be false }
  end

  describe '#can_manage?' do
    subject { guest.can_manage?('anything') }
    it { should be false }
  end

  describe '#display_name' do
    subject { guest.display_name }
    it { should eq 'Guest' }
  end

  describe '#logged_in?' do
    subject { guest.logged_in? }
    it { should be false }
  end

  describe '#pledged?' do
    subject { guest.pledged?('anything') }
    it { should be false }
  end

  describe '#pledge_for' do
    subject { guest.pledge_for('anything') }
    it { should be nil }
  end
end
