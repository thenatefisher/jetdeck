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
    
    collection = new Jetdeck.Collections.ContactsCollection()
    collection = window.router.contacts if window.router.contacts
    collection.create(@model.toJSON(),
      success: (c) =>
        @model = c
        mixpanel.track("Created Contact", {}, =>
          window.location.href = "/contacts/#{@model.id}"
          modalClose()
        )

      error: (c, jqXHR) =>
        errors = $.parseJSON(jqXHR.responseText)[0]
        @$(".email_group").addClass("error")
        @$(".email_group").children(".help-block").removeClass("hide")
        @$(".email_group").children(".help-block").html(errors)
    )

  render: ->
    $(@el).html(@template( ))
    @$("form").backboneLink(@model)
    return this
