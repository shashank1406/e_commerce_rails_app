class OrdersController < ApplicationController
    before_action :authenticate_user
    
    def create
        @order = Order.find_or_initialize_by(user_id: @current_user_id,status: 'CART')
        @line_item = @order.line_items.find_by_product_id(params[:product_id])

        if @line_item
            @line_item.update({quantity: params[:quantity],price: params[:price]})
        else
            @order.line_items.build({product_id: params[:product_id], quantity: params[:quantity],price: params[:price] })
        end

        if @order.save
            render json: @order, status: :created
        else
            render json: @order.errors.full_messages, status: :unprocessable_entity
        end
    end
    
    def index
        @orders = Order.find_by(user_id: @current_user_id, status: 'CART')
        line_item = @orders.line_items
        response = []

        auth_header = request.headers['Authorization']
        token = auth_header.split(' ').last if auth_header

        line_item.each do |item|
            product = HTTParty.get("http://localhost:3002/product/#{item.product_id}",headers: {Authorization: "Bearer #{token}"} )
            response.push({**product.parsed_response, quantity:item.quantity})
        end

        if @orders
            render json: {order_detail: @orders, products: response} , status: :ok
        else
            render json: {message: 'not found'}, status: :unprocessable_entity
        end
    end

    def update
        @order = Order.find_by(user_id: @current_user_id, status: 'CART')
        if @order
            @line_item = @order.line_items.find_by_product_id(params[:product_id])
            if @line_item
                @line_item.update(line_item_update_params)
            else
                render json: {message: 'not found'}, status: :unprocessable_entity
            end
        else
            render json: {message: 'not found'}, status: :unprocessable_entity
        end
    end

    def destroy
        @order = Order.find_by(user_id: @current_user_id, status: 'CART')
        if @order
            @line_item = @order.line_items.find_by_product_id(params[:product_id])
            if @line_item.destroy
                render json: {message: 'romoved product from cart successfully'}, status: :ok
            else
                render json: {message: 'failed to remove'}, status: :unprocessable_entity
            end
        else
            render json: {message: 'not found'}, status: :unprocessable_entity
        end
    end

    private

    def genrate_order_params
       params.permit(:name,:description,:price,images:[])
    end

    def line_item_update_params
        params.permit(:quantity)
     end
       
end
