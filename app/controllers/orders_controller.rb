class OrdersController < ApplicationController
  before_action :authenticate_customer!

  def index
    @orders = current_customer.orders
                              .includes(order_items: :product)
                              .order(created_at: :desc)
  end
end