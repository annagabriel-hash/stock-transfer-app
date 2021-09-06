Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users
  root 'users#dashboard'
  namespace :admin do
    resources :users, only: %i[index show edit update]
    patch 'users/:id/approve', to: 'users#approve', as: 'user_approve'
  end
  get 'my_dashboard', to: 'users#dashboard'
  get 'user/:id/verify', to: 'users#verify', as: 'user_verify'
  get 'user/:id/confirm', to: 'users#confirm', as: 'user_confirm'
  patch 'user/:id/confirm', to: 'users#upgrade'
  get 'search_stock', to: 'stocks#search'
  post 'search_stock', to: 'orders#create'
end
