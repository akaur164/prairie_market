class Order < ApplicationRecord
  STATUSES = %w[new paid shipped].freeze

  belongs_to :customer

  has_many :order_items, dependent: :destroy

  validates :subtotal,
          :tax_total,
          :total,
          presence: true,
          numericality: { greater_than_or_equal_to: 0 }

validates :status,
          presence: true,
          inclusion: { in: STATUSES }

  before_validation :set_default_status, on: :create

  def mark_as_paid!
    update!(status: "paid")
  end

  def mark_as_shipped!
    update!(status: "shipped")
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at
      customer_id
      gst
      hst
      id
      pst
      status
      subtotal
      tax_total
      total
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[customer order_items]
  end

  private

  def set_default_status
    self.status = "new" if status.blank?
  end
end