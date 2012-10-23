class Jetdeck.Models.ContactModel extends Backbone.Model
    paramRoot: "contact"

    defaults:
      company: null
      first: null
      last: null
      email: null
      phone: null
        
    initialize : =>
      ## specs collection
      @specs = new Jetdeck.Collections.SpecsCollection(page_size: 10)
      @specs.contact = this
      
      ## actions collection
      @actions = new Jetdeck.Collections.ActionsCollection()
      @actions.contact = this      

      ## notes collection
      @notes = new Jetdeck.Collections.NotesCollection(page_size: 3)
      @notes.contact = this      
      
      ## ownership collection
      @ownership = new Jetdeck.Collections.OwnershipCollection(page_size: 5)
      @ownership.contact = this         
      
      ## custom details collection
      @custom_details = new Jetdeck.Collections.CustomDetailsCollection()
      @custom_details.contact = this            

      ## populate child collections
      @updateChildren()
    
    updateChildren : =>
      @specs.reset @get('specs')
      @actions.reset @get('actions')
      @notes.reset @get('notes')
      @ownership.reset @get('ownerships')
      @custom_details.reset @get('custom_details')
        
class Jetdeck.Collections.ContactCollection extends Backbone.CollectionBook

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
