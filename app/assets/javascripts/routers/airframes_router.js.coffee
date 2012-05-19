class Jetdeck.Routers.AirframesRouter extends Backbone.Router
  initialize: (options) ->
    @airframes = new Jetdeck.Collections.AirframesCollection()
    @airframes.reset options.airframes

  routes:
    "new"      : "newAirframe"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newAirframe: ->
    @view = new Jetdeck.Views.Airframes.NewView(collection: @airframes)
    $("#airframes").html(@view.render().el)

  index: ->
    airframes = new Jetdeck.Collections.AirframesCollection()
    airframes.fetch ( success: =>
        @view = new Jetdeck.Views.Airframes.IndexView(airframes: airframes)
        $("#airframes").html(@view.render().el)
    )
    
  show: (id) ->
    airframe = @airframes.get(id)

    @view = new Jetdeck.Views.Airframes.ShowView(model: airframe)
    $("#airframes").html(@view.render().el)

  edit: (id) ->
    airframe = @airframes.get(id)

    @view = new Jetdeck.Views.Airframes.EditView(model: airframe)
    $("#airframes").html(@view.render().el)
