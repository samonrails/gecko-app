class ProductsController < ApplicationController
  def index
    @products = access_token.get("/products").parsed["products"] if access_token
  end

  def show
    @product = access_token.get("/products/#{params[:id]}").parsed["product"]
  end

  def new
  end

  def create
    access_token.post("/products", params: {product: {name: params[:name]}})
    redirect_to root_url
  end
end
