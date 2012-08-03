Jetdeck.Views.Engines ||= {}

class Jetdeck.Views.Engines.AddModalItem extends Backbone.View
  template: JST["templates/airframes/spec/engines/item"]

  render : ->
    $(@el).html(@template(@model.toJSON() ))
    return this
