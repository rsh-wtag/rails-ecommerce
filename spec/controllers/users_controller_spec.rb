require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) { attributes_for(:user) }
  let(:invalid_attributes) { { name: '', email: 'invalid', password: 'short' } }
  let(:user) { create(:user) }

  describe 'GET #index' do
    it 'should return a success response' do
      user
      get :index
      response.should be_successful
    end
  end

  describe 'GET #show' do
    it 'should return a success response' do
      get :show, params: { id: user.to_param }
      response.should be_successful
    end
  end

  describe 'GET #new' do
    it 'should return a success response' do
      get :new
      response.should be_successful
    end
  end

  describe 'GET #edit' do
    it 'should return a success response' do
      get :edit, params: { id: user.to_param }
      response.should be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'should create a new User' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'should redirect to the created user' do
        post :create, params: { user: valid_attributes }
        response.should redirect_to(User.last)
      end
    end

    context 'with invalid params' do
      it "should return a success response (i.e., to display the 'new' template)" do
        post :create, params: { user: invalid_attributes }
        response.should be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'Jane Doe' } }

      it 'should update the requested user' do
        put :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        user.name.should eq('Jane Doe')
      end

      it 'should redirect to the user' do
        put :update, params: { id: user.to_param, user: valid_attributes }
        response.should redirect_to(user)
      end
    end

    context 'with invalid params' do
      it "should return a success response (i.e., to display the 'edit' template)" do
        put :update, params: { id: user.to_param, user: invalid_attributes }
        response.should be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'should destroy the requested user' do
      user
      expect do
        delete :destroy, params: { id: user.to_param }
      end.to change(User, :count).by(-1)
    end

    it 'should redirect to the users list' do
      delete :destroy, params: { id: user.to_param }
      response.should redirect_to(users_url)
    end
  end
end
