class AddStripePaymentDetailsToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :stripe_session_id, :string
    add_column :orders, :stripe_payment_intent_id, :string
  end
end
