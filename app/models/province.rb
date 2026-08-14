class Province < ApplicationRecord
  validates :name, :code, presence: true
  validates :code, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    %w[
      code
      created_at
      gst_rate
      hst_rate
      id
      name
      pst_rate
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
