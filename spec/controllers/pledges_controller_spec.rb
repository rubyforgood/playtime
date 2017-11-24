# frozen_string_literal: true

require 'rails_helper'

describe PledgesController, type: :controller do
  let(:pledging_user) { create(:user) }
  let(:admin) { create(:admin) }

  # This should return the minimal set of attributes required to create a valid
  # Pledge. As you add validations to Pledge, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { user_id: pledging_user.id, wishlist_item_id: create(:wishlist_item).id }
  end
  let(:invalid_attributes) { { quantity: -1 } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PledgesController. Be sure to keep this updated too.
  let(:guest_session) { {} } # intentionally blank
  let(:user_session)  { { user_id: pledging_user.id } }
  let(:admin_session) { { user_id: admin.id } }

  describe 'GET #index' do
    context 'as a normal user' do
      it 'DOES NOT return a success response' do
        create(:pledge, :with_user)
        get :index, params: {}, session: user_session
        expect(response).not_to be_success
      end
    end

    context 'as an admin' do
      it 'returns a success response' do
        create(:pledge, :with_user)
        get :index, params: {}, session: admin_session
        expect(response).to be_success
      end
    end
  end

  describe 'GET #show' do
    context 'as a normal user' do
      it 'DOES NOT return a success response' do
        pledge = create(:pledge, :with_user)
        get :show, params: { id: pledge.id }, session: user_session
        expect(response).not_to be_success
      end
      it 'redirects to the root url' do
        pledge = create(:pledge, :with_user)
        get :show, params: { id: pledge.id }, session: user_session
        expect(response).to redirect_to(root_url)
      end
    end

    context 'as the pledging user' do
      it 'returns a success response' do
        pledge = create(:pledge, user: pledging_user)
        get :show, params: { id: pledge.id }, session: user_session
        expect(response).to be_success
      end
    end

    context 'as an admin' do
      it 'returns a success response' do
        pledge = create(:pledge, :with_user)
        get :show, params: { id: pledge.id }, session: admin_session
        expect(response).to be_success
      end
    end
  end

  describe 'GET #edit' do
    context 'as a normal user' do
      it 'DOES NOT return a success response' do
        pledge = create(:pledge, :with_user)
        get :edit, params: { id: pledge.id }, session: user_session
        expect(response).not_to be_success
      end
      it 'redirects to the root url' do
        pledge = create(:pledge, :with_user)
        get :edit, params: { id: pledge.id }, session: user_session
        expect(response).to redirect_to(root_url)
      end
    end

    context 'as the pledging user' do
      it 'returns a success response' do
        pledge = create(:pledge, user: pledging_user)
        get :edit, params: { id: pledge.id }, session: user_session
        expect(response).to be_success
      end
    end

    context 'as an admin' do
      it 'returns a success response' do
        pledge = create(:pledge, :with_user)
        get :edit, params: { id: pledge.id }, session: admin_session
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    context 'as a normal user' do
      let(:new_attributes) { { quantity: 2 } }

      it 'DOES NOT update the requested pledge' do
        pledge = create(:pledge, :with_user, quantity: 1)
        put :update, params: { id: pledge.id, pledge: new_attributes },
                     session: user_session
        pledge.reload
        expect(pledge.quantity).to eq(1)
      end
    end

    context 'as the pledging user' do
      context 'with valid params' do
        let(:new_attributes) { { quantity: 2 } }

        it 'updates the requested pledge' do
          pledge = create(:pledge, user: pledging_user, quantity: 1)
          put :update, params: { id: pledge.id, pledge: new_attributes },
                       session: user_session
          pledge.reload
          expect(pledge.quantity).to eq(2)
        end

        it 'redirects to the pledge' do
          pledge = create(:pledge, user: pledging_user)
          put :update, params: { id: pledge.id, pledge: new_attributes },
                       session: user_session
          expect(response).to redirect_to(pledge)
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          pledge = create(:pledge, user: pledging_user)
          put :update, params: { id: pledge.id, pledge: invalid_attributes },
                       session: user_session
          expect(response).to be_success
        end
      end
    end

    context 'as an admin' do
      context 'with valid params' do
        let(:new_attributes) { { quantity: 2 } }

        it 'updates the requested pledge' do
          pledge = create(:pledge, :with_user, quantity: 1)
          put :update, params: { id: pledge.id, pledge: new_attributes },
                       session: admin_session
          pledge.reload
          expect(pledge.quantity).to eq(2)
        end

        it 'redirects to the pledge' do
          pledge = create(:pledge, :with_user)
          put :update, params: { id: pledge.id, pledge: new_attributes },
                       session: admin_session
          expect(response).to redirect_to(pledge)
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          pledge = create(:pledge, :with_user)
          put :update, params: { id: pledge.id, pledge: invalid_attributes },
                       session: admin_session
          expect(response).to be_success
        end
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Pledge' do
        expect do
          post :create, params: { pledge: valid_attributes }, session: {}
        end.to change(Pledge, :count).by(1)
      end

      it 'redirects to the created pledge' do
        post :create, params: { pledge: valid_attributes }, session: {}
        expect(response).to redirect_to(Pledge.last)
      end
    end

    context 'with invalid params' do
      it 'returns a failure response' do
        post :create, params: { pledge: invalid_attributes }, session: {}
        expect(response).not_to be_success
      end
    end

    context 'when the pledge already exists' do
      let(:original_pledge) { create(:pledge, user: pledging_user) }
      let!(:repeat_attributes) do
        valid_attributes.merge(
          user_id: original_pledge.user.id,
          wishlist_item_id: original_pledge.wishlist_item.id
        )
      end

      it 'DOES NOT create a new Pledge' do
        expect do
          post :create, params: { pledge: repeat_attributes }, session: {}
        end.not_to change(Pledge, :count)
      end

      it 'increments the existing pledge quantity' do
        post :create, params: { pledge: repeat_attributes }, session: {}
        expect(original_pledge.reload.quantity).to eq 2
      end

      it 'redirects to the created pledge' do
        post :create, params: { pledge: repeat_attributes }, session: {}
        expect(response).to redirect_to(original_pledge)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a normal user' do
      it 'DOES NOT destroy the requested pledge' do
        pledge = create(:pledge, :with_user)
        expect do
          delete :destroy, params: { id: pledge.to_param }, session: user_session
        end.not_to change(Pledge, :count)
      end
    end

    context 'as the pledging user' do
      it 'destroys the requested pledge' do
        pledge = create(:pledge, user: pledging_user)
        expect do
          delete :destroy, params: { id: pledge.to_param }, session: user_session
        end.to change(Pledge, :count).by(-1)
      end

      it 'redirects to the user page' do
        pledge = create(:pledge, user: pledging_user)
        delete :destroy, params: { id: pledge.to_param }, session: user_session
        expect(response).to redirect_to(pledging_user)
      end
    end

    context 'as an admin' do
      it 'destroys the requested pledge' do
        pledge = create(:pledge, :with_user)
        expect do
          delete :destroy, params: { id: pledge.to_param }, session: admin_session
        end.to change(Pledge, :count).by(-1)
      end

      it 'redirects to the user page' do
        pledge = create(:pledge, user: pledging_user)
        delete :destroy, params: { id: pledge.to_param }, session: admin_session
        expect(response).to redirect_to(pledging_user)
      end
    end
  end
end
