class ProductsController < ApplicationController
  def index
    @categories = Category.order(:name)
    @products = Product.includes(:category)

    # Filter by category
    if params[:category].present?
      @products = @products.where(category_id: params[:category])
    end

    # Search by product name or description
    if params[:search].present?
      search_text = Product.sanitize_sql_like(params[:search].strip)

      @products = @products.where(
        "products.name LIKE :search OR products.description LIKE :search",
        search: "%#{search_text}%"
      )
    end

    # Sort products
    @products =
      case params[:sort]
      when "recently_added"
        @products.order(created_at: :desc)
      when "recently_updated"
        @products.order(updated_at: :desc)
      when "name_asc"
        @products.order(name: :asc)
      when "name_desc"
        @products.order(name: :desc)
      when "price_low"
        @products.order(price: :asc)
      when "price_high"
        @products.order(price: :desc)
      else
        @products.order(created_at: :desc)
      end

    # Kaminari pagination (12 products per page)
    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.find(params[:id])
  end
end