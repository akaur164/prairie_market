class ProductsController < ApplicationController
  def index
    @categories = Category.order(:name)
    @products = Product.includes(:category)

    if params[:category].present?
      @products = @products.where(category_id: params[:category])
    end

    if params[:search].present?
      @products = @products.where(
        "LOWER(products.name) LIKE :query OR LOWER(products.description) LIKE :query",
        query: "%#{params[:search].downcase}%"
      )
    end
  end

  def show
    @product = Product.find(params[:id])
  end
end