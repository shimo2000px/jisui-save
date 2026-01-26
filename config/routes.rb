Rails.application.routes.draw do

  resources :recipes do
    member do
      get :copy
      patch :toggle_public
    end
    resources :cooking_records, only: [ :create ]
  end

  get    "login",   to: "sessions#new"
  post   "login",   to: "sessions#create"
  delete "logout",  to: "sessions#destroy"

  post "guest_login", to: "sessions#guest_login"

  post "/auth/:provider", to: ->(env) { [ 404, {}, [ "Not Found" ] ] }, as: :auth_at_provider
  match "auth/:provider/callback", to: "sessions#create", via: [ :get, :post ]
  get "auth/failure", to: redirect("/login")

  resource :profile, only: [ :show, :edit, :update, :destroy ]

  get "terms", to: "static_pages#terms", as: :terms
  get "privacy", to: "static_pages#privacy", as: :privacy
  get "contact", to: "static_pages#contact", as: :contact

  get "guide", to: "static_pages#guide", as: :guide

  namespace :admin do
    resources :users, only: [ :index, :destroy ]
  end

  resources :shares, only: [ :show ]

  resources :goals, only: [ :index, :edit, :update, :destroy ]
    

  root "recipes#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
