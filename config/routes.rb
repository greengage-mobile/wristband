Rails::Application.routes.draw do

  post '/login', :to => 'sessions#create'
  get '/login', :to => 'sessions#new'
  get '/logout', :to => 'sessions#destroy'
  match '/forgot_password', :to => 'sessions#forgot_password'

  resources :users
  match '/register', :to => 'users#new'

end
