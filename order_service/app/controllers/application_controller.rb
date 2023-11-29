class ApplicationController < ActionController::API

    JWT_SECRET = Rails.application.credentials.secret_key_base
    
    def authenticate_user
        auth_header = request.headers['Authorization']
        token = auth_header.split(' ').last if auth_header

        if token.blank?
            render json: {errors: "you must provide a token"}, status: :forbidden
        else
            begin
                decoded_token = JWT.decode(token, JWT_SECRET, true, {algorithim: 'HS256'})
                @current_user_id = decoded_token[0]['user_id']
                @token = token
            rescue JWT::DecodeError =>e
                render json: {errors: "invalid token"}, status: :unauthorized
            end 
        end
    end    
end
