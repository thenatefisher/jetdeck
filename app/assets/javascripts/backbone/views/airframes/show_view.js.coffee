Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowView extends Backbone.View
  template: JST["backbone/templates/airframes/show"]

  render: ->
    @model.fetch(
      success: () =>
        $(@el).html(@template(@model.toJSON() ))
      failure: () ->
    )

    return this
