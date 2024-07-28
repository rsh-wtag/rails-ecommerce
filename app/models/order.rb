class Order < ApplicationRecord
  belongs_to :user
  has_one :payment, dependent: :destroy

  enum status: { pending: 0, confirmed: 1, cancelled: 2 }
  enum shipping_status: { not_shipped: 0, in_transit: 1, delivered: 2 }

  validates :order_date, presence: true
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :shipping_address, presence: true
end
