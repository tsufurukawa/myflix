Myflix::Application.routes.draw do
  get '/home', to: 'videos#index'
  get '/genre/:id', to: 'categories#show', as: 'genre'

  resources :videos, only: [:show] do 
    resources :reviews, only: [:create]
    collection do 
      get :search, to: 'videos#search'
    end
  end

  namespace :admin do
    resources :videos, only: [:new, :create]
  end

  get '/register', to: 'users#new'
  get '/register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  resources :users, only: [:create, :show]
  resources :relationships, only: [:destroy, :create]
  get '/people', to: 'relationships#index'

  get '/my_queue', to: 'queue_items#index'
  resources :queue_items, only: [:create, :destroy]
  patch '/update_queue', to: 'queue_items#update_queue'

  get '/forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get '/confirm_password_reset', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show, :create]
  get '/invalid_token', to: 'pages#invalid_token'

  get '/invite', to: 'invitations#new'
  resources :invitations, only: [:create]

  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
end
