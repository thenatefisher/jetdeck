Jetdeck.Views.Airframes ||= {}

# This is a pane inside the specification tab container

class Jetdeck.Views.Airframes.ShowDescriptionPane extends Backbone.View
  template: JST["templates/airframes/spec/description/pane"]

  render: ->
    $(@el).html(@template() )
    
    return this
