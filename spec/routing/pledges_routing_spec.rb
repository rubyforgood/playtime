require "rails_helper"

RSpec.describe PledgesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/pledges").to route_to("pledges#index")
    end

    it "routes to #new" do
      expect(:get => "/pledges/new").to route_to("pledges#new")
    end

    it "routes to #show" do
      expect(:get => "/pledges/1").to route_to("pledges#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/pledges/1/edit").to route_to("pledges#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/pledges").to route_to("pledges#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/pledges/1").to route_to("pledges#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/pledges/1").to route_to("pledges#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pledges/1").to route_to("pledges#destroy", :id => "1")
    end

  end
end
