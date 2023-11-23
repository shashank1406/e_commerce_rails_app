require 'rails_helper'

RSpec.describe User, type: :model do

  describe "validations" do 

    it "is valid for valid attributes" do 
     user = build(:user, password: "testpassword", password_confirmation: "testpassword")
     expect(user).to be_valid
    end
 
    it "is not valid without an email" do 
     user = build(:user, email: nil)
     expect(user).not_to be_valid
    end
 
    it "is not valid with a duplicate email" do 
     create(:user, email: "duplicate@email.com")
     user = build(:user, email: "duplicate@email.com")
     expect(user).to be_invalid
    end

    it "is not valid when email does not match the format" do 
      user = build(:user, email: "email@.com")
      expect(user).to be_invalid
    end

    it "is not valid when password_confirmation oes not match the password" do 
      user = build(:user, password: nil, password_confirmation: "test")
      expect(user).to be_invalid
    end
 
  end

  describe "token methodes" do 

    let(:user) {create(:user)}

    it "encodes  and decodes payload and return  token" do
      payload = {user_id: user.id}
      token = User.encode_token(payload)
      expect(token).not_to be_nil

      decode_token= User.decode_token(token)
      expect(decode_token["user_id"]).to eq(user.id)
    end
 
  end
end
