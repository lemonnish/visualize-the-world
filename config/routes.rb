Rails.application.routes.draw do
  root  'static_pages#home'
  get   '/about',   to: 'static_pages#about'
  get   '/example', to: 'static_pages#example'
  get   '/contact', to: 'static_pages#contact'
  get   '/signup',  to: 'users#new'
  post  '/signup',  to: 'users#create'
  get   '/login',   to: 'sessions#new'
  post  '/login',   to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resource :user,   only: [:edit, :show, :update, :destroy]
  resources :maps
  resources :map_contents, only: [:create, :update, :destroy]
end
