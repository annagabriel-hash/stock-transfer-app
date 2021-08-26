Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users
  root 'users#dashboard'
  namespace :admin do
    resources :users, only: %i[index show edit update]
    patch 'users/:id/approve', to: 'users#approve', as: 'user_approve'
  end
  get 'my_dashboard', to: 'users#dashboard'
end
