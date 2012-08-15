Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ConfirmDelete extends Backbone.View
  template: JST["templates/contacts/partials/confirm_delete"]
  
  events:
    "click .confirm_delete_contact"  : "delete"
  
  delete: ->
    @model.destroy()
    window.location.href = "/contacts"
    
  render: ->
    $(@el).html(@template() )
    return this
