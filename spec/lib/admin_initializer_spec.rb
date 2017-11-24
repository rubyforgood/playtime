# frozen_string_literal: true

require 'rails_helper'
require 'admin_initializer'

describe AdminInitializer do
  let(:out) do
    out = double('STDOUT')
    allow(out).to receive(:puts)
    out
  end

  describe '#env' do
    before do
      allow(ENV).to receive(:[]).with('ADMIN_NAME') { '' }
      allow(ENV).to receive(:[]).with('ADMIN_AMAZON_EMAIL') { '' }
    end
    subject { AdminInitializer.new.env }

    it 'defaults to the ENV object' do
      expect(subject).to be ENV
    end
  end

  context 'when ADMIN_AMAZON_EMAIL value is not set' do
    it 'should raise an error' do
      expect { AdminInitializer.new(env: {}, out: out) }.to raise_error(
        'Please set the ADMIN_NAME and ADMIN_AMAZON_EMAIL environment variables'
      )
    end
  end

  describe '#promote_or_create_admin' do
    let(:env) do
      {
        'ADMIN_NAME' => 'Ada Lovelace',
        'ADMIN_AMAZON_EMAIL' => 'admin@example.org'
      }
    end
    let(:initializer) { AdminInitializer.new(env: env, out: out) }

    context "when the user doesn't yet exist" do
      it 'should log a message describing the new user' do
        expect(out).to receive(:puts)
          .with('Created new admin user: Ada Lovelace <admin@example.org>')
        initializer.promote_or_create_admin
      end

      describe 'the total number of users' do
        it 'should increase by 1' do
          expect { initializer.promote_or_create_admin }.to change { User.count }.by(1)
        end
      end

      describe 'the newly created user' do
        before { initializer.promote_or_create_admin }
        subject(:admin) { User.last }

        it { should be_admin }

        it 'should have the right name' do
          expect(admin.name).to eq 'Ada Lovelace'
        end

        it 'should have the right email' do
          expect(admin.email).to eq 'admin@example.org'
        end
      end
    end

    context 'when the user already exists' do
      let!(:user) { create(:user, email: env['ADMIN_AMAZON_EMAIL']) }

      it 'should log a message describing the promotion' do
        expect(out).to receive(:puts)
          .with('Promoted admin@example.org to admin')
        initializer.promote_or_create_admin
      end

      describe 'the total number of users' do
        it 'should not change' do
          expect { initializer.promote_or_create_admin }.not_to(change { User.count })
        end
      end

      describe 'the existing user' do
        before { initializer.promote_or_create_admin }
        subject { user.reload }
        it { should be_admin }
      end
    end
  end
end
