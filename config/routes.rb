Rails.application.routes.draw do
  # Health check endpoints
  get "health", to: "health#index"
  get "health/ready", to: "health#ready"
  get "health/live", to: "health#live"

  resource :session
  resources :passwords, param: :token
  root "store#index", as: "store_index"
  resources :products
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
end
