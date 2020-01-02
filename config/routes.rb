Rails.application.routes.draw do

  devise_for :users, :controllers => { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'static_pages#index'
  resources :games do
    patch :forfeit
    put :forfeit
  end
  resources :pieces, only: [:show, :update]
  resources :users, only: :show
end

