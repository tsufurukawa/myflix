Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/genre/:id', to: 'categories#show', as: 'genre'
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  get '/my_queue', to: 'queue_items#index'

  resources :videos, only: [:show] do 
    resources :reviews, only: [:create]
    collection do 
      get :search, to: 'videos#search'
    end
  end

  resources :users, only: [:create, :show]
  resources :relationships, only: [:destroy, :create]
  get '/people', to: 'relationships#index'

  resources :queue_items, only: [:create, :destroy]
  patch '/update_queue', to: 'queue_items#update_queue'

  get '/forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get '/confirm_password_reset', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show, :create]
  get '/invalid_token', to: 'password_resets#invalid_token'
end
