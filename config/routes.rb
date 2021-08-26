Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'splash1', to: 'pages#splash1'
  get 'splash2', to: 'pages#splash2'
  get 'splash3', to: 'pages#splash3'
  resources :places do
    collection do
      get :overview
      get :swipe
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
