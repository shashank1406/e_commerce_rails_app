require 'rails_helper'

RSpec.describe "Products", type: :request do

  describe "post /product" do

    let(:token) {JWT.genrate_jwt_token({user_id: 20})}

    let(:valid_attributes) do 
      {
      name:"test product",
      description:"product description",
      price:1234
      }
    end

    context "with valid parameters" do 

      before do 
        post '/product', params: valid_attributes
      end 

     it "creates a product" do 
      p token
      expect(Product.count).to be(1)
      expect(Product.last.name).to eq(valid_attributes[:name])
     end

    end

    context "with invalid parameters" do 
      before do 
        Product.create(name:"test",description:"test descriptio",price:100)
      end 
      it "returns a error if name already exist" do 
        post '/product',params: {name:"test",description:"test descriptio",price:100}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["error"][0]).to include("Name has already been taken")
      end

      it "returns a error when name is not present" do 
        post '/product',params: {name:"",description:"test descriptio",price:100}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["error"]).to include("Name can't be blank")
      end

      it "returns a error when description is not present" do 
        post '/product',params: {name:"test",description:"",price:100}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["error"]).to include("Description can't be blank")
      end

      it "returns a error when price is present" do 
        post '/product',params: {name:"test",description:"test descriptio"}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["error"]).to include("Price can't be blank")
      end

    end

    context "with valid images" do 

      let(:valid_image) {fixture_file_upload(Rails.root.join('spec/fixtures/files', 'image.png'), 'image/png')}

      it "returns a error if image correct" do 
        post '/product',params: {name:"test",description:"test descriptio",price:100,images:[valid_image]}
        expect(response).to have_http_status(:created)
        expect(json_response).to include("image_urls")
      end

    end

    context "with invalid images" do 
      let(:invalid_image) {fixture_file_upload(Rails.root.join('spec/fixtures/files', 'dummy.pdf'), 'dummy/pdf')}
    
      it "returns a error if image is incorrect" do 
        post '/product',params: {name:"test",description:"test descriptio",price:100,images:[invalid_image]}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["error"][0]).to include("must be a JPEG or PNG or GIF")
      end
    end
    
  end
end
