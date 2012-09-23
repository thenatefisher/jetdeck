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
        mixpanel.track("Created Contact", {}, =>
          window.location.href = "/contacts#/#{@model.id}"
          modalClose()
        )

      error: (c, jqXHR) =>
        errObj = $.parseJSON(jqXHR.responseText)
        if (errObj.email)
            @$(".email_group").addClass("error")
            @$(".email_group").children(".help-block").removeClass("hide")
            if errObj.email[0]
                @$(".email_group").children(".help-block").html(errObj.email[0])
    )

  render: ->
    $(@el).html(@template( ))
    @$("form").backboneLink(@model)
    return this
