Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ContactView extends Backbone.View
  template: JST["templates/contacts/contact"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
