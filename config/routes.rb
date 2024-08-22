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
end
