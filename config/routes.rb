# config/routes.rb
Rails.application.routes.draw do
  # get 'static_pages/home'
  root "static_pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  post "sign_up", to: "shoppers#create"
  get  "sign_up", to: "shoppers#new"

  resources :confirmations, only: [:create, :edit, :new], param: :confirmation_token

  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get    "login",  to: "sessions#new"

  resources :passwords, only: [:create, :edit, :new, :update], param: :password_reset_token

  put    "account", to: "shoppers#update"
  get    "account", to: "shoppers#edit"
  delete "account", to: "shoppers#destroy"

  resources :active_sessions, only: [:destroy] do
    collection do
      delete "destroy_all"
    end
  end

end
