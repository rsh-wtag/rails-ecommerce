require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      order = build(:order)
      expect(order).to be_valid
    end

    it 'is not valid without an order_date' do
      order = build(:order, order_date: nil)
      expect(order).to_not be_valid
      expect(order.errors[:order_date]).to include("can't be blank")
    end

    it 'is not valid without a total_amount' do
      order = build(:order, total_amount: nil)
      expect(order).to_not be_valid
      expect(order.errors[:total_amount]).to include("can't be blank")
    end

    it 'is not valid with a negative total_amount' do
      order = build(:order, total_amount: -1)
      expect(order).to_not be_valid
      expect(order.errors[:total_amount]).to include('must be greater than or equal to 0')
    end

    it 'is not valid without a shipping_address' do
      order = build(:order, shipping_address: nil)
      expect(order).to_not be_valid
      expect(order.errors[:shipping_address]).to include("can't be blank")
    end
  end

  describe 'enums' do
    it 'defaults status to pending' do
      order = create(:order)
      expect(order.status).to eq('pending')
    end

    it 'defaults shipping_status to not_shipped' do
      order = create(:order)
      expect(order.shipping_status).to eq('not_shipped')
    end
  end
end
