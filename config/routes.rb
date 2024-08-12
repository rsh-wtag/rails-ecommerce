Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  resources :users do
    resource :cart, only: %i[create show edit update destroy] do
      resources :cart_items, only: %i[create edit update destroy]
    end
  end

  resources :products do
    resources :reviews
  end

  resources :reviews, only: %i[edit update destroy]
  resources :categories

  resources :orders do
    resources :order_items
    resources :payments, only: %i[new create edit update destroy]
  end

  resources :order_items

  resources :carts do
    resources :cart_items
  end

  resources :cart_items

  resources :payments, only: %i[index show]
end
