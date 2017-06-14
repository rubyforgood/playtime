require 'rails_helper'

describe WishlistsController do

  # This should return the minimal set of attributes required to create a valid
  # Wishlist. As you add validations to Wishlist, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes)   { {name: "DC General"} }
  let(:invalid_attributes) { {name: nil} }

  let(:admin) { create(:admin) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # WishlistsController. Be sure to keep this updated too.
  let(:guest_session) {} # intentionally blank
  let(:admin_session) { {user_id: admin.id} }


  describe "GET #index" do
    it "returns a success response" do
      wishlist = Wishlist.create! valid_attributes
      get :index, params: {}, session: guest_session
      expect(response).to be_success
    end
  end


  describe "GET #show" do
    it "returns a success response" do
      wishlist = Wishlist.create! valid_attributes
      get :show, params: {id: wishlist.to_param}, session: guest_session
      expect(response).to be_success
    end
  end


  describe "GET #new" do
    context "as a guest" do
      it "DOES NOT return a success response" do
        get :new, params: {}, session: guest_session
        expect(response).not_to be_success
      end

      it "redirects to the root url" do
        get :new, params: {}, session: guest_session
        expect(response).to redirect_to root_url
      end
    end

    context "as an admin" do
      it "returns a success response" do
        get :new, params: {}, session: admin_session
        expect(response).to be_success
      end
    end
  end


  describe "GET #edit" do
    context "as a guest" do
      it "DOES NOT return a success response" do
        wishlist = Wishlist.create! valid_attributes
        get :edit, params: {id: wishlist.to_param}, session: guest_session
        expect(response).not_to be_success
      end

      it "redirects to the root url" do
        get :new, params: {}, session: guest_session
        expect(response).to redirect_to root_url
      end
    end

    context "as an admin" do
      it "returns a success response" do
        wishlist = Wishlist.create! valid_attributes
        get :edit, params: {id: wishlist.to_param}, session: admin_session
        expect(response).to be_success
      end
    end
  end


  describe "POST #create" do
    context "as a guest" do
      it "DOES NOT creates a new Wishlist" do
        expect {
          post :create,
          params: {wishlist: valid_attributes},
          session: guest_session
        }.not_to change(Wishlist, :count)
      end

      it "DOES NOT return a success response" do
        post :create, params: {wishlist: valid_attributes},
                      session: guest_session
        expect(response).not_to be_success
      end
    end

    context "as an admin" do
      context "with valid params" do
        it "creates a new Wishlist" do
          expect {
            post :create,
            params: {wishlist: valid_attributes},
            session: admin_session
          }.to change(Wishlist, :count).by(1)
        end

        it "redirects to the created wishlist" do
          post :create, params: {wishlist: valid_attributes},
                        session: admin_session
          expect(response).to redirect_to(Wishlist.last)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {wishlist: invalid_attributes},
                        session: admin_session
          expect(response).to be_success
        end
      end
    end
  end


  describe "PUT #update" do
    context "as a guest" do
      let(:new_attributes) { {name: "Annandale General"} }

      it "DOES NOT update the wishlist" do
        wishlist = Wishlist.create! valid_attributes
        put :update, params: {id: wishlist.to_param,
                              wishlist: new_attributes},
                     session: guest_session
        wishlist.reload
        expect(wishlist.name).to eq valid_attributes[:name]
      end

      it "DOES NOT return a success response" do
        wishlist = Wishlist.create! valid_attributes
        put :update, params: {id: wishlist.to_param,
                              wishlist: valid_attributes},
                     session: guest_session
        expect(response).not_to be_successful
      end
    end

    context "as an admin" do
      context "with valid params" do
        let(:new_attributes) { {name: "Annandale General"} }

        it "updates the requested wishlist" do
          wishlist = Wishlist.create! valid_attributes
          put :update, params: {id: wishlist.to_param,
                                wishlist: new_attributes},
                       session: admin_session
          wishlist.reload
          expect(wishlist.name).to eq "Annandale General"
        end

        it "redirects to the wishlist" do
          wishlist = Wishlist.create! valid_attributes
          put :update, params: {id: wishlist.to_param,
                                wishlist: valid_attributes},
                       session: admin_session
          expect(response).to redirect_to(wishlist)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          wishlist = Wishlist.create! valid_attributes
          put :update, params: {id: wishlist.to_param,
                                wishlist: invalid_attributes},
                       session: admin_session
          expect(response).to be_success
        end
      end
    end
  end


  describe "DELETE #destroy" do
    context "as an admin" do
      it "destroys the requested wishlist" do
        wishlist = Wishlist.create! valid_attributes
        expect {
          delete :destroy, params: {id: wishlist.to_param},
                           session: admin_session
        }.to change(Wishlist, :count).by(-1)
      end

      it "redirects to the root url" do
        wishlist = Wishlist.create! valid_attributes
        delete :destroy, params: {id: wishlist.to_param},
                         session: admin_session
        expect(response).to redirect_to(root_url)
      end
    end

    context "as a guest" do
      it "DOES NOT destroy the requested wishlist" do
        wishlist = Wishlist.create! valid_attributes
        expect {
          delete :destroy, params: {id: wishlist.to_param},
                           session: guest_session
        }.not_to change(Wishlist, :count)
      end

      it "redirects to the root url" do
        wishlist = Wishlist.create! valid_attributes
        delete :destroy, params: {id: wishlist.to_param},
                         session: guest_session
        expect(response).to redirect_to(root_url)
      end
    end
  end

end
