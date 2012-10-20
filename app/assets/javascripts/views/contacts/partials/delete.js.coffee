Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowDelete extends Backbone.View
  template: JST["templates/contacts/partials/delete"]

  events:
    "click #delete-section" : "toggleDelete"

  toggleDelete: ->
  
    if $("#delete-button").is(":visible")
      $("#delete-button").hide()
    else
      $("#delete-button").show()

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
