class Jetdeck.Routers.BookmarkletRouter extends Backbone.Router

  initialize: (options) ->
    @options = options
  
  routes:
    ".*"       : "index"

  index: ->
    @view = new Jetdeck.Views.Bookmarklet.IndexView()
    jetdeck_$("#jetdeck").html(@view.render().el)

  success: ->
    @view = new Jetdeck.Views.Bookmarklet.SuccessView()
    jetdeck_$("#jetdeck").html(@view.render().el)    

  error: ->
    @view = new Jetdeck.Views.Bookmarklet.ErrorView()
    jetdeck_$("#jetdeck").html(@view.render().el) 

   duplicate: (airframe) ->
    @view = new Jetdeck.Views.Bookmarklet.DuplicateView(airframe)
    jetdeck_$("#jetdeck").html(@view.render().el) 
       