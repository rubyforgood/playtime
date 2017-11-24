# frozen_string_literal: true

require 'rails_helper'

describe UsersController do
  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      name: 'Pete Conrad',
      email: 'pconrad@nasa.gov',
      admin: false
    }
  end

  let(:invalid_attributes) { { email: nil } }

  let(:normal_user) { create(:user) }
  let(:admin) { create(:admin) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:guest_session) { {} } # intentionally blank
  let(:user_session)  { { user_id: normal_user.id } } # intentionally blank
  let(:admin_session) { { user_id: admin.id } }

  describe 'GET #index' do
    context 'as a normal user' do
      it 'DOES NOT return a success response' do
        User.create! valid_attributes
        get :index, params: {}, session: user_session
        expect(response).not_to be_success
      end
    end

    context 'as an admin' do
      it 'returns a success response' do
        User.create! valid_attributes
        get :index, params: {}, session: admin_session
        expect(response).to be_success
      end
    end
  end

  describe 'GET #show' do
    context 'as a normal user' do
      it 'DOES NOT return a success response' do
        user = User.create! valid_attributes
        get :show, params: { id: user.to_param }, session: user_session
        expect(response).not_to be_success
      end
      it 'redirects to the root url' do
        user = User.create! valid_attributes
        get :show, params: { id: user.to_param }, session: user_session
        expect(response).to redirect_to(root_url)
      end
    end

    context 'as an admin' do
      it 'returns a success response' do
        user = User.create! valid_attributes
        get :show, params: { id: user.to_param }, session: admin_session
        expect(response).to be_success
      end
    end
  end

  describe 'GET #edit' do
    context 'as a normal user' do
      it 'DOES NOT return a success response' do
        user = User.create! valid_attributes
        get :edit, params: { id: user.to_param }, session: user_session
        expect(response).not_to be_success
      end
      it 'redirects to the root url' do
        user = User.create! valid_attributes
        get :edit, params: { id: user.to_param }, session: user_session
        expect(response).to redirect_to(root_url)
      end
    end

    context 'as an admin' do
      it 'returns a success response' do
        user = User.create! valid_attributes
        get :edit, params: { id: user.to_param }, session: admin_session
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    context 'as a normal user' do
      let(:new_attributes) { { email: 'pete.conrad@nasa.gov' } }

      it 'DOES NOT update the requested user' do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: new_attributes },
                     session: user_session
        user.reload
        expect(user.email).to eq(valid_attributes[:email])
      end
    end

    context 'as an admin' do
      context 'with valid params' do
        let(:new_attributes) { { email: 'pete.conrad@nasa.gov' } }

        it 'updates the requested user' do
          user = User.create! valid_attributes
          put :update, params: { id: user.to_param, user: new_attributes },
                       session: admin_session
          user.reload
          expect(user.email).to eq('pete.conrad@nasa.gov')
        end

        it 'redirects to the user' do
          user = User.create! valid_attributes
          put :update, params: { id: user.to_param, user: valid_attributes },
                       session: admin_session
          expect(response).to redirect_to(user)
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          user = User.create! valid_attributes
          put :update, params: { id: user.to_param, user: invalid_attributes },
                       session: admin_session
          expect(response).to be_success
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a normal user' do
      before { user_session } # initialize outside of expect block
      it 'DOES NOT destroy the requested user' do
        user = User.create! valid_attributes
        expect do
          delete :destroy, params: { id: user.to_param }, session: user_session
        end.not_to change(User, :count)
      end
    end

    context 'as an admin' do
      before { admin_session } # initialize outside of expect block

      it 'destroys the requested user' do
        user = User.create! valid_attributes
        expect do
          delete :destroy, params: { id: user.to_param }, session: admin_session
        end.to change(User, :count).by(-1)
      end

      it 'redirects to the users list' do
        user = User.create! valid_attributes
        delete :destroy, params: { id: user.to_param }, session: admin_session
        expect(response).to redirect_to(users_url)
      end

      it 'does not allow the last admin to delete their account' do
        expect(User.admin.count).to eq 1
        delete :destroy, params: { id: admin.to_param }, session: admin_session
        expect(User.admin).to exist
      end
    end
  end
end
