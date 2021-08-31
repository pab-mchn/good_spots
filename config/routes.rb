Rails.application.routes.draw do
  devise_for :users
  root to: 'places#overview'
  get 'splash1', to: 'pages#splash1'
  get 'splash2', to: 'pages#splash2'
  get 'splash3', to: 'pages#splash3'
  get 'splash4', to: 'pages#splash4'
  
  resources :viewings, only: [:index, :destroy]
  resources :places do
    resources :viewings, only: [:create]
    collection do
      get :overview
      get :swipe
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
