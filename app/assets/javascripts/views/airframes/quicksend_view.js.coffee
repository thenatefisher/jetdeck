Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.QuickSend extends Backbone.View
  template: JST["templates/airframes/quicksend"]


  initialize: () ->
    @model = new Jetdeck.Models.AirframeModel()

  render: =>
    $(@el).html(@template( ))

    @$("form").backboneLink(@model)

    return this
