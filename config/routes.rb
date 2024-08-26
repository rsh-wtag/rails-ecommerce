Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users
  resource :cart, only: :show
  resources :cart_items, only: %i[create update destroy]
  resources :users do
    resource :cart do
      member do
        post 'checkout'
      end
      resources :cart_items
    end
    resources :orders
  end

  resources :products do
    resources :reviews
  end

  resources :reviews
  resources :categories

  resources :orders do
    resources :order_items
  end

  resources :carts do
    member do
      post :checkout
    end
  end

  resources :order_items

  resources :carts do
    resources :cart_items
  end

  resources :cart_items

  resources :orders do
    resource :payment
  end

  resources :orders do
    member do
      get :email_preview
    end
  end

  resource :dashboard, only: [:show], controller: 'users', as: 'user_dashboard'

  # Admin routes
  namespace :admin do
    resource :dashboard, only: [:show], controller: 'users', as: 'admin_dashboard'
    resources :orders, only: %i[index show update destroy]
    resources :products, only: %i[index new create edit update destroy]
    resources :categories, only: %i[index new create edit update destroy]
  end

  resources :products do
    get 'delete_image/:image_id', to: 'products#delete_image', as: :delete_image
  end
end
