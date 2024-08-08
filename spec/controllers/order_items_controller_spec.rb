require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:order) { create(:order, user:) }
  let(:product) { create(:product) }
  let(:order_item) { create(:order_item, order:, product:) }

  describe 'GET #index' do
    before { get :index, params: { order_id: order.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:order_items)).to eq([order_item]) }
  end

  describe 'GET #show' do
    before { get :show, params: { order_id: order.id, id: order_item.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:order_item)).to eq(order_item) }
  end

  describe 'GET #new' do
    before { get :new, params: { order_id: order.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:order_item)).to be_a_new(OrderItem) }
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        product_id: product.id,
        quantity: 2,
        price: 50.0
      }
    end

    let(:invalid_attributes) do
      {
        product_id: nil,
        quantity: -1,
        price: -10.0
      }
    end

    context 'with valid parameters' do
      it 'creates a new OrderItem and redirects to the order' do
        expect do
          post :create, params: { order_id: order.id, order_item: valid_attributes }
        end.to change(OrderItem, :count).by(1)

        created_order_item = OrderItem.last
        expect(response).to redirect_to(order_path(order))
      end
    end

    context 'with invalid parameters' do
      before { post :create, params: { order_id: order.id, order_item: invalid_attributes } }

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
      before { patch :update, params: { order_id: order.id, id: order_item.id, order_item: new_attributes } }

      it { is_expected.to redirect_to(order_path(order)) }
      it { expect(order_item.reload.quantity).to eq(5) }
    end

    context 'with invalid parameters' do
      before { patch :update, params: { order_id: order.id, id: order_item.id, order_item: invalid_attributes } }

      it { is_expected.to render_template(:edit) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:order_item_to_destroy) { create(:order_item, order:, product:) }

    it 'destroys the requested order item and redirects to the order' do
      expect do
        delete :destroy, params: { order_id: order.id, id: order_item_to_destroy.id }
      end.to change(OrderItem, :count).by(-1)

      expect(response).to redirect_to(order_path(order))
    end
  end
end
