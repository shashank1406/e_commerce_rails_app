require 'rails_helper'

RSpec.describe "Orders", type: :request do

  let(:token) {JWTHelper.genrate_jwt_token({user_id: 1})}

  let(:inValidToken) {JWTHelper.genrate_jwt_token({user_id: 2})}


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
  
  describe "post /order" do
    
    context "with valid parameters" do 

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

  describe "get /orders" do

    context "with valid token" do 
     it "should return reponse with products" do 
      get '/orders', headers: {'Authorization': "Bearer #{token}"}
      expect(response).to have_http_status(:ok)
      expect(response.body['products']).not_to be_nil
      expect(response.body).to include('order_detail')
     end
    end

    context "with invalid token" do 
      it "should return reponse with products" do 
       get '/orders', headers: {'Authorization': "Bearer #{inValidToken}"}
       expect(response).to have_http_status(:unprocessable_entity)
       expect(response.body).to include('not found')
      end
     end

  end

  describe "put /order/:product_id" do

    context "with valid token" do 

      it "should update the line item quentity" do 
       put '/order/1',params: {quantity:2},  headers: {'Authorization': "Bearer #{token}"}
       expect(response).to have_http_status(:ok)
       expect(response.body).to include("product quantity updated sucessfully")
       expect(LineItem.last.quantity).to eq(2)
      end

      it "should return error with incorrect product_id" do 
       put '/order/2',params: {quantity:2},  headers: {'Authorization': "Bearer #{token}"}
       expect(response).to have_http_status(:unprocessable_entity)
       expect(response.body).to include("failed to remove")
       expect(LineItem.last.quantity).to eq(1)
      end

    end

    context "with invalid token" do 

      it "should update the line item quentity" do 
       put '/order/1',params: {quantity:2},  headers: {'Authorization': "Bearer #{inValidToken}"}
       expect(response).to have_http_status(:unprocessable_entity)
       expect(response.body).to include("not found")
      end
 
    end
  end

  describe "delete /order/:product_id" do

    context "with valid token" do

      it "should delete the line item " do 
        delete '/order/1',  headers: {'Authorization': "Bearer #{token}"}
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("romoved product from cart successfully")
        expect(LineItem.last).to be_nil
      end

      it "should return error with incorrect product_id" do 
        delete '/order/2',  headers: {'Authorization': "Bearer #{token}"}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("failed to delete")
        expect(LineItem.last).not_to be_nil
       end

    end

    context "with invalid token" do

      it "should delete the line item " do 
        delete '/order/1',  headers: {'Authorization': "Bearer #{inValidToken}"}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("not found")
      end

    end

  end

end
