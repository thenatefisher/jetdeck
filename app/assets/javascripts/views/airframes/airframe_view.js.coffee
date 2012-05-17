Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.AirframeView extends Backbone.View
  template: JST["templates/airframes/airframe"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()
    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
