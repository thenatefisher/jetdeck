class Jetdeck.Routers.ActionsRouter extends Backbone.Router

  initialize: (options) ->
    @options = options
  
  routes:
    ".*"       : "index"

  index: ->
    actions = new Jetdeck.Collections.ActionsCollection()
    actions.reset @options.actions  
    @view = new Jetdeck.Views.Actions.IndexView(actions: actions)
    $("#html_top").html(@view.render().el)


