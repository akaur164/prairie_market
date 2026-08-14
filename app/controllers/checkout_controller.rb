class CheckoutController < ApplicationController
  before_action :initialize_cart
  before_action :load_cart, only: [ :new, :create, :create_session ]

  def new
  end

  def create
    if @cart_items.empty?
      redirect_to products_path, alert: "Your cart is empty."
      return
    end

    customer = current_customer
    taxes = calculate_taxes(@subtotal, customer.province)

    order = create_order(customer, taxes)

    session[:cart] = {}

    redirect_to order_path(order), notice: "Your order was placed."
  end

  def show
    @order = Order.includes(:customer, order_items: :product)
                  .find(params[:id])
  end

  def create_session
    if @cart_items.empty?
      redirect_to products_path, alert: "Your cart is empty."
      return
    end

    customer = current_customer
    taxes = calculate_taxes(@subtotal, customer.province)

    order = create_order(customer, taxes)

    stripe_session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      mode: "payment",

      line_items: [
        {
          price_data: {
            currency: "cad",
            product_data: {
              name: "Prairie Market Order ##{order.id}"
            },
            unit_amount: (order.total * 100).round
          },
          quantity: 1
        }
      ],

      metadata: {
        order_id: order.id.to_s
      },

      success_url:
        "#{checkout_success_url}?session_id={CHECKOUT_SESSION_ID}",

      cancel_url: checkout_url
    )

    order.update!(
      stripe_session_id: stripe_session.id
    )

    redirect_to stripe_session.url,
                allow_other_host: true,
                status: :see_other

  rescue Stripe::StripeError => e
    order&.destroy

    redirect_to checkout_path,
                alert: "Stripe payment error: #{e.message}"
  end

  def success
    stripe_session =
      Stripe::Checkout::Session.retrieve(params[:session_id])

    order_id = stripe_session.metadata.order_id
    order = Order.find(order_id)

    if stripe_session.payment_status == "paid"
      order.update!(
        status: "paid",
        stripe_session_id: stripe_session.id,
        stripe_payment_intent_id: stripe_session.payment_intent
      )

      session[:cart] = {}

      redirect_to order_path(order),
                  notice: "Payment successful! Your order is now paid."
    else
      redirect_to checkout_path,
                  alert: "Payment was not completed."
    end

  rescue Stripe::StripeError, ActiveRecord::RecordNotFound => e
    redirect_to checkout_path,
                alert: "Unable to confirm payment: #{e.message}"
  end

  private

  def initialize_cart
    session[:cart] ||= {}
  end

  def load_cart
    product_ids = session[:cart].keys

    products = Product.where(id: product_ids).index_by do |product|
      product.id.to_s
    end

    @cart_items = session[:cart].filter_map do |product_id, quantity|
      product = products[product_id.to_s]
      next unless product

      {
        product: product,
        quantity: quantity.to_i,
        subtotal: product.price * quantity.to_i
      }
    end

    @subtotal = @cart_items.sum { |item| item[:subtotal] }
  end

  def create_order(customer, taxes)
    order = customer.orders.create!(
      subtotal: @subtotal,
      gst: taxes[:gst],
      pst: taxes[:pst],
      hst: taxes[:hst],
      tax_total: taxes[:tax_total],
      total: @subtotal + taxes[:tax_total],
      status: "new"
    )

    @cart_items.each do |item|
      order.order_items.create!(
        product: item[:product],
        quantity: item[:quantity],
        unit_price: item[:product].price,
        subtotal: item[:subtotal]
      )
    end

    order
  end

  def customer_params
    params.permit(
      :name,
      :email,
      :address,
      :city,
      :province,
      :postal_code
    )
  end

  def calculate_taxes(subtotal, province_code)
    province = Province.find_by(code: province_code)

    unless province
      raise ActiveRecord::RecordNotFound,
            "Province with code #{province_code} was not found."
    end

    gst = (subtotal * province.gst_rate.to_d).round(2)
    pst = (subtotal * province.pst_rate.to_d).round(2)
    hst = (subtotal * province.hst_rate.to_d).round(2)

    {
      gst: gst,
      pst: pst,
      hst: hst,
      tax_total: (gst + pst + hst).round(2)
    }
  end
end
