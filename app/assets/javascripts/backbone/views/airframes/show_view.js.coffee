Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowView extends Backbone.View
  template: JST["backbone/templates/airframes/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
