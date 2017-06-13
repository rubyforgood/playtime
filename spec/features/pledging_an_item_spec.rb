require "rails_helper"
require "support/omniauth"

feature "Pledging an item:" do
  before do
    create(:pledge, id: 100)
  end

  # context "As a guest" do
    # scenario "I can purchase a wish list item"
    # scenario "I can confirm that an item was purchased"
  # end

  context "As an admin" do
    before { login(as: :admin) }
    after { reset_amazon_omniauth }

    scenario "I can view a list of pledges" do
      click_link "Pledges"
      expect(find_all(".pledge").count).to eq 1
    end

    scenario "I can delete an existing pledge" do
      visit pledges_path
      within find_all(".pledge").first do
        click_link "Destroy"
      end

      expect(find_all(".pledge").count).to eq 0
    end

    # Do these make sense?
    # --------------------
    # scenario "I can view the details of a specific pledge"
    # scenario "I can create a new pledge"
    # scenario "I can edit an existing pledge"

    scenario "I can export pledges as a CSV file" do
      visit pledges_path
      click_link "Export CSV"

      expect(page).to have_text "id," # should be a csv...
      expect(page).to have_text "100" # ...with pledge data
    end
  end
end
