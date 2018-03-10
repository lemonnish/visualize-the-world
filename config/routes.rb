Rails.application.routes.draw do
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/example', to: 'static_pages#example'
  get '/contact', to: 'static_pages#contact'
end
