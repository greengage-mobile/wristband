Rails.application.routes.draw do
  post '/login' => 'sessions#create'
  get '/login' => 'sessions#new'
  get '/logout' => 'sessions#destroy'

  resources :users  
  resources :passwords, :only => [:new, :create, :edit, :update]
end
