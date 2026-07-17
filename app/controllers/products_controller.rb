class ProductsController < ApplicationController
  PRODUCTS_PER_PAGE = 12

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

    # Sort and filter products
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

    # Pagination
    @total_products = @products.count
    @total_pages = [
      (@total_products.to_f / PRODUCTS_PER_PAGE).ceil,
      1
    ].max

    requested_page = params.fetch(:page, 1).to_i
    @current_page = requested_page.clamp(1, @total_pages)

    @products = @products
                .limit(PRODUCTS_PER_PAGE)
                .offset((@current_page - 1) * PRODUCTS_PER_PAGE)
  end

  def show
    @product = Product.find(params[:id])
  end
end