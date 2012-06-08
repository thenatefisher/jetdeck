Jetdeck.Views.Profile ||= {}

class Jetdeck.Views.Profile.ShowView extends Backbone.View
  template: JST["templates/profile/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    return this
