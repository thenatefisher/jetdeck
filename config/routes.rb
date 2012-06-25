Jetdeck::Application.routes.draw do

  resources :contacts

  match "/airframes/models" => "airframes#models"

  resources :airframes

  resources :equipment

  resources :xspecs
  
  resources :engines

  resources :accessories, :only => [:index, :create, :destroy]

  match "/login" => "sessions#new"

  match "/authenticate" => "sessions#create"

  match "/logout" => "sessions#destroy"

  match "/profile" => "users#show"

  match "/s/:code" => "xspecs#show"

  match "/s" => "xspecs#recordTimeOnPage"

  root :to => 'sessions#new'

end
