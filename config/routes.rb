Jetdeck::Application.routes.draw do

  resources :credits

  resources :xspecs

  resources :users

  resources :contacts

  resources :airports

  resources :airframes

  resources :sessions

  match "/s/:code" => "xspecs#show"
  match "/s" => "xspecs#recordTimeOnPage"
  root :to => 'index#index'

end
