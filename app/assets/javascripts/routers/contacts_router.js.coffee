class Jetdeck.Routers.ContactsRouter extends Backbone.Router
  
  initialize: (options) ->
    @options = options

  routes:
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"       : "index"

  index: ->
    contacts = new Jetdeck.Collections.ContactCollection(page_size: 15)
    contacts.reset @options.contacts 
    @view = new Jetdeck.Views.Contacts.IndexView(contacts: contacts)
    $("#html_top").html(@view.render().el)
    
  show: (id) ->
    contact = new Jetdeck.Models.ContactModel(@options.contact)
    contact.url = "/contacts/" + contact.id
    @view = new Jetdeck.Views.Contacts.ShowView(model: contact)
    $("#html_top").html(@view.render().el)

  edit: (id) ->
    contact = @contacts.get(id)
    @view = new Jetdeck.Views.Contacts.EditView(model: contact)
    $("#contacts").html(@view.render().el)
