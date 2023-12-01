class OrderProcessService
    def initialize(line_item,token)
        @line_item = line_item
        @token = token
    end

    def get_products_by_ids()
        response = []
        @line_item.each do |item|
            product = HTTParty.get("http://localhost:3002/product/#{item.product_id}",headers: {Authorization: "Bearer #{@token}"} )
            response.push({**product.parsed_response, quantity:item.quantity})
        end
        response
        
    end
end