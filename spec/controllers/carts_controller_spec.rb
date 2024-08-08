require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user:) }

  describe 'GET #show' do
    before { get :show, params: { id: cart.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:cart)).to eq(cart) }
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: cart.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:cart)).to eq(cart) }
  end

  describe 'PATCH #update' do
    let(:new_attributes) do
      { item_count: 5 }
    end

    let(:invalid_attributes) do
      { item_count: -1 }
    end

    context 'with valid parameters' do
      before { patch :update, params: { id: cart.id, cart: new_attributes } }

      it { is_expected.to redirect_to(cart) }
      it { expect(cart.reload.item_count).to eq(5) }
    end

    context 'with invalid parameters' do
      before { patch :update, params: { id: cart.id, cart: invalid_attributes } }

      it { is_expected.to render_template(:edit) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:cart_to_destroy) { create(:cart, user:) }

    it 'destroys the requested cart and redirects to root_path' do
      expect do
        delete :destroy, params: { id: cart_to_destroy.id }
      end.to change(Cart, :count).by(-1)

      expect(response).to redirect_to(root_path)
    end
  end
end
