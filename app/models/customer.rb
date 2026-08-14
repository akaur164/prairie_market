class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :orders, dependent: :destroy

  validates :name, :email, :address, :city, :province, :postal_code,
          presence: true

validates :postal_code,
          format: {
            with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/,
            message: "must be a valid Canadian postal code"
          }
end
