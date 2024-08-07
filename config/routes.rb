Rails.application.routes.draw do
  resources :products do
    resources :reviews, only: %i[new create index show]
  end
  resources :reviews, only: %i[edit update destroy]
  resources :categories
  resources :users

  get 'up' => 'rails/health#show', as: :rails_health_check
end
