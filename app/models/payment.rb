class Payment < ApplicationRecord
  belongs_to :order

  enum payment_method: { credit_card: 0, mobile_banking: 1, bank_transfer: 2, cash_on_delivery: 3 }
  enum payment_status: { pending: 0, completed: 1, failed: 2 }

  validates :order_id, presence: true, uniqueness: true
  validates :payment_method, presence: true
  validates :payment_status, presence: true
  validates :payment_date, presence: true
end
