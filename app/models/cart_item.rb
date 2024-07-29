class CartItem < ApplicationRecord
  belongs_to :cart, dependent: :destroy
  belongs_to :product

  validates :cart_item, presence: true
  validates :product_id, presense: true, uniqueness: true
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
end
