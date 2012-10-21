Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowDelete extends Backbone.View
  template: JST["templates/contacts/partials/delete"]
  
  events:
    "click #delete-section"     : "toggleDelete"
    "click #delete-confirm"     : "delete"
    "click #delete-cancel"      : "toggleDelete"
    
  delete: () ->
    @model.destroy()
    mixpanel.track("Deleted Contact", {}, ->
      window.location.href = "/contacts"
    )
    
  toggleDelete: ->
  
    if $("#delete-button").is(":visible")
      $("#delete-button").hide()
    else
      $("#delete-button").show()

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
