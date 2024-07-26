class Product < ApplicationRecord
  belongs_to :category

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :stock_quantity, presence: true
  validates :SKU, presence: true,
                  format: { with: /\A[A-Z0-9]+\z/, message: 'only allows uppercase letters and numbers' }
  validates :category_id, presence: true
end
