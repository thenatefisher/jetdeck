Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.EditView extends Backbone.View
  template : JST["backbone/templates/airframes/edit"]

  events :
    "submit #edit-airframe" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (airframe) =>
        @model = airframe
        window.location.hash = "/#{@model.id}"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
