class Jetdeck.Routers.AirframesRouter extends Backbone.Router

  initialize: (options) ->
    @options = options
  
  routes:
    "new"      : "newAirframe"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"       : "index"

  newAirframe: ->
    @view = new Jetdeck.Views.Airframes.NewView(collection: @airframes)
    $("#airframes").html(@view.render().el)

  index: ->
    airframes = new Jetdeck.Collections.AirframesCollection(page_size: 10)
    airframes.reset @options.airframes  
    @view = new Jetdeck.Views.Airframes.IndexView(airframes: airframes)
    $("#html_top").html(@view.render().el)

  show: (id) ->
    airframe = new Jetdeck.Models.AirframeModel(@options.airframe)
    airframe.url = "/airframes/" + airframe.id
    @view = new Jetdeck.Views.Airframes.ShowView(model: airframe)
    $("#html_top").html(@view.render().el)

  edit: (id) ->
    airframe = @airframes.get(id)
    @view = new Jetdeck.Views.Airframes.EditView(model: airframe)
    $("#html_top").html(@view.render().el)
