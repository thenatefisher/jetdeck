Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.NewView extends Backbone.View
  template: JST["templates/contacts/new"]

  events:
    "click #new_contact": "save"

  initialize: () ->
    @model = new Jetdeck.Models.ContactModel()

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    collection = new Jetdeck.Collections.ContactCollection()
    collection = window.router.contacts if window.router.contacts
    collection.create(@model.toJSON(),
      success: (c) =>
        @model = c
        window.location.href = "/contacts#/#{@model.id}"
        modalClose()

      error: (c, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template( ))
    @$("form").backboneLink(@model)
    return this
