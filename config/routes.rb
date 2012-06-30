Jetdeck::Application.routes.draw do

  get "password_resets/new"

  resources :contacts

  match "/airframes/models" => "airframes#models"

  resources :airframes

  resources :equipment

  resources :xspecs
  
  resources :engines

  resources :password_resets

  resources :accessories, :only => [:index, :create, :destroy, :update]

  match "/login" => "sessions#new"

  match "/authenticate" => "sessions#create"

  match "/logout" => "sessions#destroy"

  match "/profile" => "users#show"

  match "/s/:code" => "xspecs#show"

  match "/s" => "xspecs#recordTimeOnPage"

  root :to => 'sessions#new'

end
