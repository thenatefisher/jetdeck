Jetdeck.Views.Leads ||= {}

class Jetdeck.Views.Leads.NewView extends Backbone.View
  template: JST["backbone/templates/leads/new"]

  events:
    "submit #new-lead": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (lead) =>
        @model = lead
        window.location.hash = "/#{@model.id}"

      error: (lead, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
