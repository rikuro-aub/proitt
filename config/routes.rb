Rails.application.routes.draw do
  get 'introductions/show'
  get 'terms/show'
  get 'privacy_policies/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'videos#index'
  resources :tags, only: [:index]
  get 'auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get 'search', to: 'videos#search'
  get 'inquiry', to: 'inquiries#show'
  get 'privacy_policy', to: 'privacy_policies#show'
  get 'term', to: 'terms#show'
  get 'introduction', to: 'introductions#show'

  resources :videos, only: [:index, :show] do
    resources :comments
    resources :favorites, only: [:create, :destroy]
  end

  resources :users, only: [:show, :destroy] do
    resources :comments, only: [:index, :show]
    resources :favorites, only: [:index]
    get 'delete', to: 'users#delete'

    resources :comments, only: [:destroy] do
      member do
        delete 'from_my_page_destroy'
      end
    end
  end
end
