Jetdeck::Application.routes.draw do

  resources :credits

  resources :xspecs

  resources :users

  resources :contacts

  resources :airports

  resources :airframes

  resources :sessions

  resources :equipment
  
  match "/s/:code" => "xspecs#show"
  match "/s" => "xspecs#recordTimeOnPage"
  root :to => 'index#index'

end
#== Route Map
# Generated on 26 Apr 2012 19:32
#
#               POST   /credits(.:format)            credits#create
#    new_credit GET    /credits/new(.:format)        credits#new
#   edit_credit GET    /credits/:id/edit(.:format)   credits#edit
#        credit GET    /credits/:id(.:format)        credits#show
#               PUT    /credits/:id(.:format)        credits#update
#               DELETE /credits/:id(.:format)        credits#destroy
#        xspecs GET    /xspecs(.:format)             xspecs#index
#               POST   /xspecs(.:format)             xspecs#create
#     new_xspec GET    /xspecs/new(.:format)         xspecs#new
#    edit_xspec GET    /xspecs/:id/edit(.:format)    xspecs#edit
#         xspec GET    /xspecs/:id(.:format)         xspecs#show
#               PUT    /xspecs/:id(.:format)         xspecs#update
#               DELETE /xspecs/:id(.:format)         xspecs#destroy
#         users GET    /users(.:format)              users#index
#               POST   /users(.:format)              users#create
#      new_user GET    /users/new(.:format)          users#new
#     edit_user GET    /users/:id/edit(.:format)     users#edit
#          user GET    /users/:id(.:format)          users#show
#               PUT    /users/:id(.:format)          users#update
#               DELETE /users/:id(.:format)          users#destroy
#      contacts GET    /contacts(.:format)           contacts#index
#               POST   /contacts(.:format)           contacts#create
#   new_contact GET    /contacts/new(.:format)       contacts#new
#  edit_contact GET    /contacts/:id/edit(.:format)  contacts#edit
#       contact GET    /contacts/:id(.:format)       contacts#show
#               PUT    /contacts/:id(.:format)       contacts#update
#               DELETE /contacts/:id(.:format)       contacts#destroy
#      airports GET    /airports(.:format)           airports#index
#               POST   /airports(.:format)           airports#create
#   new_airport GET    /airports/new(.:format)       airports#new
#  edit_airport GET    /airports/:id/edit(.:format)  airports#edit
#       airport GET    /airports/:id(.:format)       airports#show
#               PUT    /airports/:id(.:format)       airports#update
#               DELETE /airports/:id(.:format)       airports#destroy
#     airframes GET    /airframes(.:format)          airframes#index
#               POST   /airframes(.:format)          airframes#create
#  new_airframe GET    /airframes/new(.:format)      airframes#new
# edit_airframe GET    /airframes/:id/edit(.:format) airframes#edit
#      airframe GET    /airframes/:id(.:format)      airframes#show
#               PUT    /airframes/:id(.:format)      airframes#update
#               DELETE /airframes/:id(.:format)      airframes#destroy
#      sessions GET    /sessions(.:format)           sessions#index
#               POST   /sessions(.:format)           sessions#create
#   new_session GET    /sessions/new(.:format)       sessions#new
#  edit_session GET    /sessions/:id/edit(.:format)  sessions#edit
#       session GET    /sessions/:id(.:format)       sessions#show
#               PUT    /sessions/:id(.:format)       sessions#update
#               DELETE /sessions/:id(.:format)       sessions#destroy
#                      /s/:code(.:format)            xspecs#show
#             s        /s(.:format)                  xspecs#recordTimeOnPage
#          root        /                             index#index
