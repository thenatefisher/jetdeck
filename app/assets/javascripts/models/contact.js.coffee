class Jetdeck.Models.ContactModel extends Backbone.Model
    paramRoot: "contact"

    defaults:
      company: null
      first: null
      last: null
      email: null
      phone: null
        
    initialize : =>
      ## actions collection
      @todos = new Jetdeck.Collections.TodosCollection(page_size: 9)
      @todos.airframe = this

      ## notes collection
      @notes = new Jetdeck.Collections.NotesCollection(page_size: 3)
      @notes.contact = this      
      
      ## populate child collections
      @updateChildren()
    
    updateChildren : =>
      @todos.reset @get("todos")
      @notes.reset @get("notes")
      
class Jetdeck.Collections.ContactsCollection extends Backbone.CollectionBook

    model: Jetdeck.Models.ContactModel
    
    url: "/contacts"
    
    initialize: ->
      @order = "last"
      @dx = "asc"
    
    orderBy : (o) ->
      @order = o

    direction : (d) ->
      @dx = d
      
    comparator: (i) ->
      d = 1
      d = -1 if @dx == "desc"
      
      if @order == "created_at"
          dt = new Date(i.get("created_at"))
          return d*dt

      return d * parseInt(i.get(@order), 10)    
