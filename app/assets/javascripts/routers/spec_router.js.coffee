class Jetdeck.Routers.SpecRouter extends Backbone.Router

  initialize: (options) ->
    if options && options.spec
      @spec = new Jetdeck.Models.Spec(options.spec)

  routes:
    ".*"      : "show"

  show: (id) ->
    @view = new Jetdeck.Views.Spec.ShowView(model: @spec)
    $("#spec").html(@view.render().el)
