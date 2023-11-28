class ProductController < ApplicationController

  before_action :authenticate_user

  def create
   @product = Product.new(product_params)
   attach_image if product_params[:images]
    if @product.save
      render json:@product, status: :created
    else
    render json:{error:@product.errors.full_messages},status: :unprocessable_entity
    end
  end

  def index
    @products = Product.all
    render json:@products, status: :ok
  end

  def show
    @product = Product.find_by(id: params[:id])
    if @product
      render json:@product, status: :ok
    else
    render json:{error:"not found"},status: :unprocessable_entity
    end
  end

  def destroy
    product = Product.find_by(id: params[:id])
    if product
      product.destroy
      render json:{product:product,message:"product deleted successfully"}, status: :ok
    else
    render json:{error:"not found"},status: :unprocessable_entity
    end
  end

  def update
    product = Product.find_by(id: params[:id])
    if product
      product.update(product_params)
      render json:{product:product,message:"product updated successfully"}, status: :ok
    else
    render json:{error:"not found"},status: :unprocessable_entity
    end
  end

  private
  def product_params
    params.permit(:name,:description,:price,images:[])
  end

  def attach_image
    product_params[:images].each do |image|
      @product.images.attach(image)
    end
  end
end
