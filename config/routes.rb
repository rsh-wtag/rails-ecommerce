Rails.application.routes.draw do
  resources :products do
    resources :reviews
  end
  resources :reviews, only: %i[edit update destroy]
  resources :categories
  resources :users
  resources :orders do
    resources :order_items
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
