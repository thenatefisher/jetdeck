Jetdeck.Views.Airframes ||= {}

# This is a pane inside the specification tab container

class Jetdeck.Views.Airframes.ShowAirframePane extends Backbone.View
  template: JST["templates/airframes/spec/airframe/pane"]

  render: ->
    $(@el).html(@template(@model.toJSON() ) )

    return this

