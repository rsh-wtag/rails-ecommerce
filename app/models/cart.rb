class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items

  validates :user_id, presence: true
  validates :item_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
