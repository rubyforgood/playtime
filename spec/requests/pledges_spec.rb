require 'rails_helper'

RSpec.describe "Pledges", type: :request do
  let(:admin) { User.create!(email: 'test@test.com', admin: true) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
  end

  describe "GET /pledges" do
    it "works! (now write some real specs)" do
      get pledges_path
      expect(response).to have_http_status(200)
    end
  end
end
