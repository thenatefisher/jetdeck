Jetdeck::Application.routes.draw do

  resources :contacts

  match "/airframes/models" => "airframes#models"

  resources :airframes

  resources :xspecs
  
  resources :engines

  resources :password_resets

  resources :users, :only => [:update]
  
  resources :user_logos, :only => [:index, :create, :destroy]  
  
  resources :equipment

  resources :accessories
  
  match "/login" => "sessions#new"

  match "/authenticate" => "sessions#create"

  match "/logout" => "sessions#destroy"
 
  match "/profile" => "profile#index", :via => "get"

  match "/profile" => "profile#update", :via => "put"

  match "/s/:code" => "xspecs#retail"

  match "/s" => "xspecs#recordTimeOnPage"
  
  match "/xspecs/send_spec" => "xspecs#send"
  
  match "/favicon.ico" => redirect("/assets/favicon.png")

  root :to => 'sessions#new'

end
