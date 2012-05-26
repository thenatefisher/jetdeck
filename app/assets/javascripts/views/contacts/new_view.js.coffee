Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.NewView extends Backbone.View
  template: JST["templates/contacts/new"]

  events:
    "submit #new-contact": "save"

  initialize: () ->
    #@model = new Jetdeck.Models.Contact()

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @collection.create(@model.toJSON(),
      success: (c) =>
        @model = c
        #window.location.hash = "/#{@model.id}"

      error: (c, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template( ))

    #this.$("form").backboneLink(@model)

    return this
