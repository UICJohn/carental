Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'users/registrations'
  }
  # devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :v1 do
    resources :stores, only: [:index]
    resources :vehicles, only: [:index, :show]
    resources :orders, only: [:create, :index, :show, :destroy]
    resources :payments, only: [:create]
  end
end
