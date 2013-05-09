class Jetdeck.Routers.BookmarkletRouter extends Backbone.Router

  initialize: (options) ->
    @options = options
  
  routes:
    ".*"       : "index"

  index: ->
    @view = new Jetdeck.Views.Bookmarklet.ErrorView()
    $("#jetdeck").html(@view.render().el)