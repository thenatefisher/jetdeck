Jetdeck::Application.routes.draw do
  
  resources :invites, :only => [:create]
    
  resources :notes
  
  resources :todos
  
  match "/contacts/search" => "contacts#search"

  resources :contacts

  match "/b/:token" => "bookmarklet#index"  

  match "/airframes/models" => "airframes#models"

  match "/airframes/import" => "airframes#import"

  resources :airframes

  resources :password_resets
  
  match "/signup/:token" => "users#new"
  
  match "/signup" => "users#new"
  
  match "/activate/:token" => "users#activate"

  resources :users, :only => [:create]
  
  resources :invites, :only => [:create]

  resources :accessories
  
  match "/search" => "search#navbar"
    
  match "/login" => "sessions#new"

  match "/authenticate" => "sessions#create"

  match "/logout" => "sessions#destroy"
 
  match "/profile" => "profile#index", :via => "get"

  match "/profile" => "profile#update", :via => "put"

  match "/s/:code" => "leads#photos"

  match "/s" => "leads#recordTimeOnPage"

  resources :leads
  
  match "/favicon.ico" => redirect("/assets/favicon.png")

  root :to => 'sessions#new'

end
