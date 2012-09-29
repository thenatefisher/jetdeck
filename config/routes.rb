Jetdeck::Application.routes.draw do

  resources :notes
  
  match "/actions" => "todos#index"
  
  resources :todos

  resources :contacts

  match "/airframes/models" => "airframes#models"

  resources :airframes

  resources :xspecs
  
  resources :engines

  resources :password_resets

  resources :users, :only => [:update]
  
  resources :user_logos 
  
  resources :equipment

  resources :accessories
  
  match "/search" => "search#navbar"
  
  match "/login" => "sessions#new"

  match "/authenticate" => "sessions#create"

  match "/logout" => "sessions#destroy"
 
  match "/profile" => "profile#index", :via => "get"

  match "/profile" => "profile#update", :via => "put"

  match "/s/:code" => "xspecs#retail"

  match "/s" => "xspecs#recordTimeOnPage"
  
  match "/xspecs/send_spec/:id" => "xspecs#send_spec"
  
  match "/favicon.ico" => redirect("/assets/favicon.png")

  root :to => 'sessions#new'

end
