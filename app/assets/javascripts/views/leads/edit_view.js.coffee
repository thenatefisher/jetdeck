Jetdeck.Views.Leads ||= {}

class Jetdeck.Views.Leads.EditView extends Backbone.View
  template : JST["backbone/templates/leads/edit"]

  events :
    "submit #edit-lead" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (lead) =>
        @model = lead
        window.location.hash = "/#{@model.id}"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
