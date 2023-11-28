Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  post 'product', to: "product#create"
  get 'product', to: "product#index"
  get 'product/:id', to: "product#show"
  delete 'product/:id', to: "product#destroy"
  put 'product/:id', to: "product#update"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
