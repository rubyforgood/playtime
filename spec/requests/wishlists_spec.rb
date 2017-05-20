require 'rails_helper'

RSpec.describe "Wishlists", type: :request do
  let(:admin) { User.create!(email: 'test@test.com', admin: true) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
  end

  describe "GET /wishlists" do
    it "works! (now write some real specs)" do
      get wishlists_path
      expect(response).to have_http_status(200)
    end
  end
end
