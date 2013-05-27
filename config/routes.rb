Jetdeck::Application.routes.draw do

  resources :details, :only => [:destroy]
  
  resources :invites, :only => [:create]
  
  resources :ownerships
  
  resources :notes
  
  match "/actions" => "todos#index"
  
  resources :todos
  
  match "/contacts/search" => "contacts#search"

  resources :contacts

  match "/b/:token" => "bookmarklet#index"  

  match "/airframes/models" => "airframes#models"

  match "/airframes/import" => "airframes#import"

  resources :airframes

  resources :xspecs
  
  resources :engines

  resources :password_resets
  
  match "/signup/:token" => "users#new"
  
  match "/signup" => "users#new"
  
  match "/activate/:token" => "users#activate"

  resources :users, :only => [:create]
  
  resources :invites, :only => [:create]
  
  resources :user_logos 
  
  resources :equipment, :only => [:destroy]

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

  root "*" => 'sessions#new'

end
