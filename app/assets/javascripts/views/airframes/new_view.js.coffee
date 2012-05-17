Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.NewView extends Backbone.View
  template: JST["templates/airframes/new"]

  events:
    "submit #new-airframe": "save"

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
      success: (airframe) =>
        @model = airframe
        window.location.hash = "/#{@model.id}"

      error: (airframe, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
