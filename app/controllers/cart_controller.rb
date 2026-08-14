class CartController < ApplicationController
  before_action :initialize_cart

  def show
    product_ids = session[:cart].keys

    @products = Product.where(id: product_ids).index_by do |product|
      product.id.to_s
    end

    @cart_items = session[:cart].filter_map do |product_id, quantity|
      product = @products[product_id.to_s]
      next unless product

      {
        product: product,
        quantity: quantity.to_i,
        subtotal: product.price * quantity.to_i
      }
    end

    @cart_total = @cart_items.sum do |item|
      item[:subtotal]
    end
  end

  def add
    product = Product.find(params[:id])
    product_id = product.id.to_s

    session[:cart][product_id] ||= 0
    session[:cart][product_id] += 1

    redirect_to cart_path,
                notice: "#{product.name} was added to your cart."
  end

  def update
    product = Product.find(params[:id])
    quantity = params[:quantity].to_i

    if quantity > 0
      session[:cart][product.id.to_s] = quantity
      notice = "#{product.name} quantity was updated."
    else
      session[:cart].delete(product.id.to_s)
      notice = "#{product.name} was removed from your cart."
    end

    redirect_to cart_path, notice: notice
  end

  def remove
    product = Product.find(params[:id])
    session[:cart].delete(product.id.to_s)

    redirect_to cart_path,
                notice: "#{product.name} was removed from your cart."
  end

  private

  def initialize_cart
    session[:cart] ||= {}
  end
end