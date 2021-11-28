Rails.application.routes.draw do
  get 'posts/new'
  #ホームページ
  root 'static_pages#home' 
  
  #ログインフォーム
  get "/login", to:"sessions#new" 
  post "/login", to:"sessions#create"
  delete "/logout", to:"sessions#destroy"  
  resources :users
  resources :account_activations, only:[:edit] #edit_account_activation_url(token) URL:/account_activation/token/edit
  resources :posts
end
