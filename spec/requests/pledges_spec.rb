require 'rails_helper'

RSpec.describe "Pledges", type: :request do
  describe "GET /pledges" do
    it "works! (now write some real specs)" do
      get pledges_path
      expect(response).to have_http_status(200)
    end
  end
end
