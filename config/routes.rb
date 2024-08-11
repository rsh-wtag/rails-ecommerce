Rails.application.routes.draw do
  resources :products do
    resources :reviews
  end

  resources :reviews, only: %i[edit update destroy]
  resources :categories
  resources :users

  resources :orders do
    resources :order_items
    resources :payments, only: %i[new create edit update destroy]
  end

  resources :carts do
    resources :cart_items
  end

  resources :payments, only: %i[index show]

  get 'up' => 'rails/health#show', as: :rails_health_check
end
