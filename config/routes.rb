Jetdeck::Application.routes.draw do

  resources :contacts

  match "/airframes/models" => "airframes#models"

  resources :airframes

  resources :xspecs
  
  resources :engines

  resources :password_resets

  resources :users, :only => [:update]
  
  resources :equipment

  resources :accessories, :only => [:index, :create, :destroy, :update]

  match "/login" => "sessions#new"

  match "/authenticate" => "sessions#create"

  match "/logout" => "sessions#destroy"
 
  match "/profile" => "profile#index", :via => "get"

  match "/profile" => "profile#update", :via => "put"

  match "/s/:code" => "xspecs#show"

  match "/s" => "xspecs#recordTimeOnPage"

  root :to => 'sessions#new'

end
