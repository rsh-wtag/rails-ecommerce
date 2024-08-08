require 'rails_helper'

RSpec.describe CartItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user:) }
  let(:product) { create(:product) }
  let(:cart_item) { create(:cart_item, cart:, product:) }

  describe 'GET #index' do
    before { get :index, params: { cart_id: cart.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:cart_items)).to eq([cart_item]) }
  end

  describe 'GET #show' do
    before { get :show, params: { cart_id: cart.id, id: cart_item.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:cart_item)).to eq(cart_item) }
  end

  describe 'GET #new' do
    before { get :new, params: { cart_id: cart.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:cart_item)).to be_a_new(CartItem) }
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        product_id: product.id,
        quantity: 2
      }
    end

    let(:invalid_attributes) do
      {
        product_id: nil,
        quantity: -1
      }
    end

    context 'with valid parameters' do
      it 'creates a new CartItem and redirects to the cart' do
        expect do
          post :create, params: { cart_id: cart.id, cart_item: valid_attributes }
        end.to change(CartItem, :count).by(1)

        created_cart_item = CartItem.last
        expect(response).to redirect_to(cart_path(cart))
      end
    end

    context 'with invalid parameters' do
      before { post :create, params: { cart_id: cart.id, cart_item: invalid_attributes } }

      it { is_expected.to render_template(:new) }
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) do
      { quantity: 5 }
    end

    let(:invalid_attributes) do
      { quantity: -1 }
    end

    context 'with valid parameters' do
      before { patch :update, params: { cart_id: cart.id, id: cart_item.id, cart_item: new_attributes } }

      it { is_expected.to redirect_to(cart_path(cart)) }
      it { expect(cart_item.reload.quantity).to eq(5) }
    end

    context 'with invalid parameters' do
      before { patch :update, params: { cart_id: cart.id, id: cart_item.id, cart_item: invalid_attributes } }

      it { is_expected.to render_template(:edit) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:cart_item_to_destroy) { create(:cart_item, cart:, product:) }

    it 'destroys the requested cart item and redirects to the cart' do
      expect do
        delete :destroy, params: { cart_id: cart.id, id: cart_item_to_destroy.id }
      end.to change(CartItem, :count).by(-1)

      expect(response).to redirect_to(cart_path(cart))
    end
  end
end
