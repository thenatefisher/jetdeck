class Jetdeck.Routers.ProfileRouter extends Backbone.Router

  initialize: (options) ->
    @profile = new Jetdeck.Models.Profile(options.profile)

  routes:
    ".*"      : "show"

  show: () ->
    @view = new Jetdeck.Views.Profile.ShowView(model: @profile)
    $("#profile").html(@view.render().el)
