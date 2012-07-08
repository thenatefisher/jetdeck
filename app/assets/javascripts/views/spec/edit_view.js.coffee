Jetdeck.Views.Spec ||= {}

class Jetdeck.Views.Spec.EditView extends Backbone.View
  template: JST["templates/spec/edit"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
