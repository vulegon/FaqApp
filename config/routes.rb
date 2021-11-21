Rails.application.routes.draw do
  #ホームページ
  root 'static_pages#home' 
  
  #ログインフォーム
  get "/login", to:"sessions#new" 
  post "/login", to:"sessions#create"
  delete "/logout", to:"sessions#destroy"  
  resources :users
end
