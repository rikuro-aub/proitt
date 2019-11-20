Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'videos#index'
  resources :tags, only: [:index]
  get 'auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get 'search', to: 'videos#search'

  resources :videos, only: [:index, :show] do
    resources :comments
    resources :favorites, only: [:create, :destroy]
  end
end
