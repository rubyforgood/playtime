# frozen_string_literal: true

require 'rails_helper'

describe WishlistsController do
  # This should return the minimal set of attributes required to create a valid
  # Wishlist. As you add validations to Wishlist, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes)   { attributes_for(:wishlist, name: 'DC General') }
  let(:invalid_attributes) { { name: nil } }

  # Sessions should return the minimal set of values that should be in the
  # session in order to pass any filters (e.g. authentication) defined in
  # WishlistsController. Be sure to keep this updated too.
  shared_context 'admin' do
    let!(:admin) { create(:admin) }
    let(:admin_session) { { user_id: admin.id } }
  end

  shared_context 'site manager' do
    let!(:site_manager) { create(:user, :with_sites) }
    let(:site_manager_wishlist) { site_manager.wishlists.first }
    let(:site_manager_session) { { user_id: site_manager.id } }
  end

  describe 'GET #show' do
    it 'returns a success response' do
      wishlist = create(:wishlist, valid_attributes)
      get :show, params: { id: wishlist.to_param }, session: {}
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    context 'as a guest' do
      it 'DOES NOT return a success response' do
        get :new, params: {}, session: {}
        expect(response).not_to be_success
      end

      it 'redirects to the root url' do
        get :new, params: {}, session: {}
        expect(response).to redirect_to root_url
      end
    end

    context 'as a site_manager' do
      include_context 'site manager'

      it 'DOES NOT return a success response' do
        get :new, params: {}, session: site_manager_session
        expect(response).not_to be_success
      end

      it 'redirects to the root url' do
        get :new, params: {}, session: site_manager_session
        expect(response).to redirect_to root_url
      end
    end

    context 'as an admin' do
      include_context 'admin'

      it 'returns a success response' do
        get :new, params: {}, session: admin_session
        expect(response).to be_success
      end
    end
  end

  describe 'GET #edit' do
    context 'as a guest' do
      let(:wishlist) { create(:wishlist, valid_attributes) }

      it 'DOES NOT return a success response' do
        wishlist = create(:wishlist, valid_attributes)
        get :edit, params: { id: wishlist.to_param }, session: {}
        expect(response).not_to be_success
      end

      it 'redirects to the root url' do
        get :edit, params: { id: wishlist.to_param }, session: {}
        expect(response).to redirect_to root_url
      end
    end

    context 'as a site manager' do
      include_context 'site manager'

      context 'for their wishlist' do
        it 'DOES NOT return a success response' do
          get :edit, params: { id: site_manager_wishlist.to_param },
                     session: site_manager_session
          expect(response).not_to be_success
        end

        it 'redirects to the root url' do
          get :edit, params: { id: site_manager_wishlist.to_param },
                     session: site_manager_session
          expect(response).to redirect_to root_url
        end
      end

      context 'for a foreign wishlist' do
        let(:wishlist) { create(:wishlist, valid_attributes) }

        it 'DOES NOT return a success response' do
          get :edit, params: { id: wishlist.to_param },
                     session: site_manager_session
          expect(response).not_to be_success
        end

        it 'redirects to the root url' do
          get :edit, params: { id: wishlist.to_param },
                     session: site_manager_session
          expect(response).to redirect_to root_url
        end
      end
    end

    context 'as an admin' do
      include_context 'admin'

      it 'returns a success response' do
        wishlist = create(:wishlist, valid_attributes)
        get :edit, params: { id: wishlist.to_param }, session: admin_session
        expect(response).to be_success
      end
    end
  end

  describe 'POST #create' do
    context 'as a guest' do
      it 'DOES NOT creates a new Wishlist' do
        expect do
          post :create,
               params: { wishlist: valid_attributes },
               session: {}
        end.not_to change(Wishlist, :count)
      end

      it 'DOES NOT return a success response' do
        post :create, params: { wishlist: valid_attributes },
                      session: {}
        expect(response).not_to be_success
      end
    end

    context 'as a site manager' do
      include_context 'site manager'

      it 'DOES NOT creates a new Wishlist' do
        expect do
          post :create,
               params: { wishlist: valid_attributes },
               session: site_manager_session
        end.not_to change(Wishlist, :count)
      end

      it 'DOES NOT return a success response' do
        post :create, params: { wishlist: valid_attributes },
                      session: site_manager_session
        expect(response).not_to be_success
      end
    end

    context 'as an admin' do
      include_context 'admin'

      context 'with valid params' do
        it 'creates a new Wishlist' do
          expect do
            post :create,
                 params: { wishlist: valid_attributes },
                 session: admin_session
          end.to change(Wishlist, :count).by(1)
        end

        it 'redirects to the created wishlist' do
          post :create, params: { wishlist: valid_attributes },
                        session: admin_session
          expect(response).to redirect_to(Wishlist.last)
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { wishlist: invalid_attributes },
                        session: admin_session
          expect(response).to be_success
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'as a guest' do
      let(:new_attributes) { { name: 'Annandale General' } }

      it 'DOES NOT update the wishlist' do
        wishlist = create(:wishlist, valid_attributes)
        put :update, params: { id: wishlist.to_param,
                               wishlist: new_attributes },
                     session: {}
        wishlist.reload
        expect(wishlist.name).to eq valid_attributes[:name]
      end

      it 'DOES NOT return a success response' do
        wishlist = create(:wishlist, valid_attributes)
        put :update, params: { id: wishlist.to_param,
                               wishlist: valid_attributes },
                     session: {}
        expect(response).not_to be_successful
      end
    end

    context 'as a site manager' do
      include_context 'site manager'

      context 'for their wishlist' do
        let(:new_attributes) { { name: 'Annandale General' } }

        it 'DOES NOT update the wishlist' do
          name = site_manager_wishlist.name
          put :update, params: { id: site_manager_wishlist.to_param,
                                 wishlist: new_attributes },
                       session: site_manager_session
          site_manager_wishlist.reload
          expect(site_manager_wishlist.name).to eq name
        end

        it 'DOES NOT return a success response' do
          put :update, params: { id: site_manager_wishlist.to_param,
                                 wishlist: valid_attributes },
                       session: site_manager_session
          expect(response).not_to be_successful
        end
      end

      context 'for a foreign wishlist' do
        let(:new_attributes) { { name: 'Annandale General' } }

        it 'DOES NOT update the wishlist' do
          wishlist = create(:wishlist, valid_attributes)
          put :update, params: { id: wishlist.to_param,
                                 wishlist: new_attributes },
                       session: site_manager_session
          wishlist.reload
          expect(wishlist.name).to eq valid_attributes[:name]
        end

        it 'DOES NOT return a success response' do
          wishlist = create(:wishlist, valid_attributes)
          put :update, params: { id: wishlist.to_param,
                                 wishlist: valid_attributes },
                       session: site_manager_session
          expect(response).not_to be_successful
        end
      end
    end

    context 'as an admin' do
      include_context 'admin'

      context 'with valid params' do
        let(:new_attributes) { { name: 'Annandale General' } }

        it 'updates the requested wishlist' do
          wishlist = create(:wishlist, valid_attributes)
          put :update, params: { id: wishlist.to_param,
                                 wishlist: new_attributes },
                       session: admin_session
          wishlist.reload
          expect(wishlist.name).to eq 'Annandale General'
        end

        it 'redirects to the wishlist' do
          wishlist = create(:wishlist, valid_attributes)
          put :update, params: { id: wishlist.to_param,
                                 wishlist: valid_attributes },
                       session: admin_session
          expect(response).to redirect_to(wishlist)
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          wishlist = create(:wishlist, valid_attributes)
          put :update, params: { id: wishlist.to_param,
                                 wishlist: invalid_attributes },
                       session: admin_session
          expect(response).to be_success
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a guest' do
      it 'DOES NOT destroy the requested wishlist' do
        wishlist = create(:wishlist, valid_attributes)
        expect do
          delete :destroy, params: { id: wishlist.to_param },
                           session: {}
        end.not_to change(Wishlist, :count)
      end

      it 'redirects to the root url' do
        wishlist = create(:wishlist, valid_attributes)
        delete :destroy, params: { id: wishlist.to_param },
                         session: {}
        expect(response).to redirect_to(root_url)
      end
    end

    context 'as a site manager' do
      include_context 'site manager'

      context 'for their wishlist' do
        it 'DOES NOT destroy the requested wishlist' do
          expect do
            delete :destroy, params: { id: site_manager_wishlist.to_param },
                             session: site_manager_session
          end.not_to change(Wishlist, :count)
        end

        it 'redirects to the root url' do
          delete :destroy, params: { id: site_manager_wishlist.to_param },
                           session: site_manager_session
          expect(response).to redirect_to(root_url)
        end
      end

      context 'for a foreign wishlist' do
        it 'DOES NOT destroy the requested wishlist' do
          wishlist = create(:wishlist, valid_attributes)
          expect do
            delete :destroy, params: { id: wishlist.to_param },
                             session: site_manager_session
          end.not_to change(Wishlist, :count)
        end

        it 'redirects to the root url' do
          wishlist = create(:wishlist, valid_attributes)
          delete :destroy, params: { id: wishlist.to_param },
                           session: site_manager_session
          expect(response).to redirect_to(root_url)
        end
      end
    end

    context 'as an admin' do
      include_context 'admin'

      it 'destroys the requested wishlist' do
        wishlist = create(:wishlist, valid_attributes)
        expect do
          delete :destroy, params: { id: wishlist.to_param },
                           session: admin_session
        end.to change(Wishlist, :count).by(-1)
      end

      it 'redirects to the root url' do
        wishlist = create(:wishlist, valid_attributes)
        delete :destroy, params: { id: wishlist.to_param },
                         session: admin_session
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
