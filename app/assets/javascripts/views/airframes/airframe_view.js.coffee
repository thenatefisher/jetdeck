Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.AirframeView extends Backbone.View
  template: JST["templates/airframes/airframe"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
