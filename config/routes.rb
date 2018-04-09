Rails.application.routes.draw do
  root  'static_pages#home'
  get   '/about',   to: 'static_pages#about'
  get   '/example', to: 'static_pages#example'
  get   '/privacy', to: 'static_pages#privacy'
  get   '/contact', to: 'static_pages#contact'
  post  '/contact', to: 'static_pages#contact_submit'
  get   '/signup',  to: 'users#new'
  post  '/signup',  to: 'users#create'
  get   '/login',   to: 'sessions#new'
  post  '/login',   to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resource :user,   only: [:edit, :show, :update, :destroy]
  resources :maps do
    patch '/map_contents',   to: 'map_contents#update', as: 'contents'
    resources :map_contents, only: [:create, :destroy],
                             as: 'contents'
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  match '/422', to: 'errors#rejected_change', via: :all
end
