require "rails_helper"

RSpec.describe WishlistsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/wishlists").to route_to("wishlists#index")
    end

    it "routes to #new" do
      expect(:get => "/wishlists/new").to route_to("wishlists#new")
    end

    it "routes to #show" do
      expect(:get => "/wishlists/1").to route_to("wishlists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/wishlists/1/edit").to route_to("wishlists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/wishlists").to route_to("wishlists#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/wishlists/1").to route_to("wishlists#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/wishlists/1").to route_to("wishlists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/wishlists/1").to route_to("wishlists#destroy", :id => "1")
    end

  end
end
