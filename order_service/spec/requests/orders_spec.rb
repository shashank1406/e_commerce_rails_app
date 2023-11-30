require 'rails_helper'

RSpec.describe "Orders", type: :request do
  
  describe "post /order" do
    let(:token) {JWTHelper.genrate_jwt_token({user_id: 20})}

    context "with valid parameters" do 

      let(:valid_attributes) do 
        {
        product_id:1,
        price:100,
        quantity:1
        }
      end

      before do 
        post '/order', params: valid_attributes, headers: {'Authorization': "Bearer #{token}"}
      end 

     it "creates a order" do 
       expect(Order.count).to be(1)
       expect(LineItem.last.product_id).to eq(valid_attributes[:product_id])
     end

     it "update a quantity when add existing product" do
      post '/order', params: valid_attributes, headers: {'Authorization': "Bearer #{token}"}
       expect(Order.count).to be(1)
       expect(LineItem.last.quantity).to be(2)
     end

    end

  end


end
