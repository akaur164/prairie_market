class Product < ApplicationRecord
  belongs_to :category

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
    ["category"]
  end
end