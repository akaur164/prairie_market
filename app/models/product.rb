class Product < ApplicationRecord
  belongs_to :category

  has_many :order_items, dependent: :restrict_with_error

  has_one_attached :image

  validates :name, presence: true
  validates :description, presence: true
  validates :price,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    [
      "category_id",
      "created_at",
      "description",
      "id",
      "name",
      "price",
      "updated_at"
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    [
      "category",
      "order_items"
    ]
  end
end
