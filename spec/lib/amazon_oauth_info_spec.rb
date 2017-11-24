# frozen_string_literal: true

require 'amazon_oauth_info'

describe 'AmazonOAuthInfo' do
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
  let(:amazon_info) { AmazonOAuthInfo.new hash }

  describe '#hash' do
    subject { amazon_info.hash }
    it { should eq hash }
  end

  describe '#amazon_user_id' do
    subject { amazon_info.amazon_user_id }
    it { should eq '1' }
  end

  describe '#email' do
    subject { amazon_info.email }
    it { should eq 'jglenn@nasa.gov' }
  end

  describe '#name' do
    subject { amazon_info.name }
    it { should eq 'John Glenn, Jr.' }
  end

  describe '#zipcode' do
    subject { amazon_info.zipcode }
    it { should eq 54_321 }
  end
end
