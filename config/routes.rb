Jetdeck::Application.routes.draw do

  resources :contacts

  resources :airframes

  resources :equipment

  resources :accessories, :only => [:index, :create, :destroy]

  match "/login" => "sessions#new"

  match "/logout" => "sessions#destroy"

  match "/profile" => "users#profile"

  match "/s/:code" => "xspecs#show"

  match "/s" => "xspecs#recordTimeOnPage"

  root :to => 'index#index'

end
