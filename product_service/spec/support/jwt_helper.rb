module JWTHelper

    JWT_SECRET = Rails.application.credentials.secrate_key_base

    def self.genrate_jwt_token(payload)
        JWT.encode(payload,JWT_SECRET,'HS256')
    end

end