class OrderItem < ApplicationRecord
  belongs_to :order
  has_one :product

  validates :order_id, presence: true
  validates :product_id, presence: true, uniquness: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
