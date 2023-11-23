require 'rails_helper'

RSpec.describe "Authentications", type: :request do

  before do 
    create(:user, email: "shashank@gmail.com",password:"shashank")
  end 
  
  describe "POST /register" do
    let(:valid_attributes) do 
      {
      email:"shashankshrivasta@gmail.com",
      password:"password",
      password_confirmation:"password"
      }
    end

    let(:invalid_attributes) do 
      {
      email:"shashankshrivasta@gmail.com",
      password:"password",
      password_confirmation:"wrong"
      }
    end

    context "with valid parameters" do 

      before do 
        post '/register',params: valid_attributes
      end 

     it "creates a User" do 
      expect(User.count).to be(2)
      expect(User.last.email).to eq(valid_attributes[:email])
     end

     it "should return a jwt token " do 
      expect(response).to have_http_status(:created)
      expect(json_response['token']).not_to be_nil
     end

     it "should return a success message " do 
      expect(json_response['message']).to eq("user created successfully")
     end

    end 

    
    context "with invalid parameters" do 
      before do 
        User.create(email:"shashank@gmail.com",password:"shashank",password_confirmation:"shashank")
      end 

      it "dose not create a user" do
        post '/register',params: invalid_attributes 
        expect(User.count).to be(1)
      end

      it "returns a error message if user is invalid" do 
        post '/register',params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors'][0]).to eq("Password confirmation doesn't match Password")
      end

      it "returns a error if email already exist" do 
        post '/register',params: {email:"shashank@gmail.com",password:"shashank",password_confirmation:"shashank"}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"][0]).to include("Email has already been taken")
      end

      it "returns a error when email is not present" do 
        post '/register',params: {email:"",password:"shashank",password_confirmation:"shashank"}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"][0]).to include("Email can't be blank")
      end

      it "returns a error when password is not present" do 
        post '/register',params: {email:"shashank@gmail.com",password:"",password_confirmation:"shashank"}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"][0]).to include("Password can't be blank")
      end

      it "returns a error when password and password_confirmation not present" do 
        post '/register',params: {email:"shashank@gmail.com",password:"",password_confirmation:""}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"][0]).to include("Password can't be blank")
      end

      it "returns a error when email is invalid" do 
        post '/register',params: {email:"shashank",password:"shashank",password_confirmation:"shashank"}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"][0]).to include("Email is invalid")
      end

      it "returns error when params is empty" do 
        post '/register',params: {}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Password can't be blank","Email can't be blank","Email is invalid")
        
      end

    end

  end

  describe "POST /login" do
    # before do 
    #   create(:user, email: "shashank@gmail.com",password:"shashank")
    # end 

    context "with valid parameters" do 

      it "login a User" do 
        post '/login',params: {email:"shashank@gmail.com",password:"shashank"}
        expect(response).to have_http_status(:ok)
        expect(json_response["message"]).to include("user login successfully")
      end

      it "should return a jwt token " do 
        post '/login',params: {email:"shashank@gmail.com",password:"shashank"}
        expect(response).to have_http_status(:ok)
        expect(json_response['token']).not_to be_nil
       end

    end 

    context "with invalid parameters" do 

      it "returns a error message if user email is invalid" do 
        post '/login',params: {email:"shashanksk@gmail.com",password:"shashank"}
        expect(response).to have_http_status(:unauthorized)
        expect(json_response["error"]).to include("unauthorized user")
      end

      it "returns a error message if user pasword is invalid" do 
        post '/login',params: {email:"shashank@gmail.com",password:"passwordss"}
        expect(response).to have_http_status(:unauthorized)
        expect(json_response["error"]).to include("unauthorized user")
      end
      
     end

  end


end
