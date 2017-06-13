# "Feature Manifest"
# ------------------
# As feature tests get fleshed out, they should be moved to more appropriate
# files. This file was created to get a better forest-level view of all
# project features.

require "rails_helper"


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
