Rails.application.routes.draw do
  resources :categories
  resources :products
  resources :users

  get 'up' => 'rails/health#show', as: :rails_health_check
end
