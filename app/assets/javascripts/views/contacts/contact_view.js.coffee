Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ContactView extends Backbone.View
  template: JST["templates/contacts/contact"]

  events:
    "click .destroy" : "destroy"
    "click" : "gotoContact"

  gotoContact: ->
    location.href = "/contacts#/" + @model.id
    return

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()
    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    $(@el).css('cursor', 'pointer')
    return this
