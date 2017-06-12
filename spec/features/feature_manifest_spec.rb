# "Feature Manifest"
# ------------------
# As feature tests get fleshed out, they should be moved to more appropriate
# files. This file was created to get a better forest-level view of all
# project features.

require "rails_helper"

feature "Items:" do
  context "As a guest" do
    scenario "I can see a list of items across all wishlists"
    # scenario "I can purchase a wish list item"
    # scenario "I can confirm that an item was purchased"
  end

  context "As a site manager" do
    # scenario "I can add a new item to my wishlist"
    # scenario "I can edit an existing item on my wishlist"
    # scenario "I can remove an item from my wishlist"
  end
end

feature "Pledges:" do
  context "As an admin" do
    scenario "I can create a new pledge"
    scenario "I can edit an existing pledge"
    scenario "I can delete an existing pledge"
    scenario "I can view a list of pledges"
    scenario "I can view the details of a specific pledge"
    scenario "I can export pledges as a CSV file"
  end
end

feature "Users:" do
  context "As an admin" do
    scenario "I can view a list of users"
    scenario "I can view details on an individual user"
    scenario "I can update a user's account details"
    scenario "I can delete a user account"
    scenario "I can export the list of users to a CSV file"
    # scenario "I can assign a user to be Site Manager of a wishlist"
  end
end
