class Jetdeck.Routers.ContactsRouter extends Backbone.Router
  
  initialize: (options) ->
    @contacts = new Jetdeck.Collections.ContactCollection()
    @contacts.reset options.contacts

  routes:
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"       : "index"

  index: ->
    @contacts = new Jetdeck.Collections.ContactCollection(page_size: 15)
    @contacts.fetch ( success: =>
        @view = new Jetdeck.Views.Contacts.IndexView(contacts: @contacts)
        $("#contacts").html(@view.render().el)
    )

  show: (id) ->
    contact = @contacts.get(id)
    @view = new Jetdeck.Views.Contacts.ShowView(model: contact)
    $("#contacts").html(@view.render().el)

  edit: (id) ->
    contact = @contacts.get(id)
    @view = new Jetdeck.Views.Contacts.EditView(model: contact)
    $("#contacts").html(@view.render().el)
