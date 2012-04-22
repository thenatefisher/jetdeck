Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.IndexView extends Backbone.View
  template: JST["backbone/templates/airframes/index"]

  initialize: () ->
    @options.airframes.bind('reset', @addAll)

  addAll: () =>
    @options.airframes.each(@addOne)

  addOne: (airframe) =>
    view = new Jetdeck.Views.Airframes.AirframeView({model : airframe})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(airframes: @options.airframes.toJSON() ))
    @addAll()

    return this
