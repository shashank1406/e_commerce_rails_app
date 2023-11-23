require 'rails_helper'

RSpec.describe AuthenticationsController, type: :controller do


    describe "POST /register" do

        let(:valid_attributes) {
          {
          email:"shashankshrivasta@gmail.com",
          password:"password",
          password_confirmation:"password"
          }
        }
    
        let(:invalid_attributes) {
          {
          email:"shashankshrivasta@gmail.com",
          password:"password",
          password_confirmation:"wrong"
          }
        }
          
        context "with valid parameters" do 

           before {post :register,params: valid_attributes} 
      
           it "creates a User" do 
            expect(response).to have_http_status(:created)
            expect(response.content_type).to include("application/json")
            expect(response.content_type).to include("charset=utf-8")
            expect(User.count).to be(1)
            expect(User.last.email).to eq(valid_attributes[:email])
           end

        end  

        context "with invalid parameters" do 

            before {post :register,params: invalid_attributes} 
       
            it "dose not create a user" do 
             expect(response).to have_http_status(:unprocessable_entity)
             expect(json_response['errors']).to be_present
            end
 
         end 

    end   

    describe "POST /login" do

        let(:user) {create(:user, email: "shashank@gmail.com",password:"shashank")}
        
        context "with valid parameters" do 
      
           it "log in the user" do 
            post :login, params: {email: user.email, password: user.password }
            expect(response).to have_http_status(:ok)
            expect(json_response['token']).to  be_present
           end

        end  

        
    end 

end