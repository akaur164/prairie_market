class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, :unit_price, :subtotal, presence: true
end
