Jetdeck::Application.routes.draw do

  resources :charges

  resources :invites, :only => [:create]

  resources :notes

  resources :todos

  match "/contacts/search" => "contacts#search"

  resources :contacts

  match "/b/:token" => "bookmarklet#index"

  match "/airframes/models" => "airframes#models"

  match "/airframes/import" => "airframes#import"

  resources :airframes

  match "/s/:code" => "airframe_messages#spec"

  match "/p/:code" => "airframe_messages#photos"

  resources :airframe_messages

  resources :airframe_specs

  resources :airframe_images

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

  match "/resend_activation" => "profile#resendActivation"

  match "/profile" => "profile#index", :via => "get"

  match "/profile" => "profile#update", :via => "put"

  match "/profile" => "profile#destroy", :via => "delete"

  resources :leads

  match "/favicon.ico" => redirect("/assets/favicon.png")

  root :to => 'sessions#new'

end
