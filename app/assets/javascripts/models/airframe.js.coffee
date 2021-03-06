class Jetdeck.Models.AirframeModel extends Backbone.Model
    paramRoot : "airframe"

    defaults :
      serial: null
      registration: null
      year: null
      make: null
      model_name: null
      asking_price: 0
      description: null
      avatar: null
      to_s: null
      long: null

    initialize : =>
      ## leads collection
      @leads = new Jetdeck.Collections.LeadsCollection()
      @leads.airframe = this
      
      ## actions collection
      @todos = new Jetdeck.Collections.TodosCollection(page_size: 9)
      @todos.airframe = this

      ## spec files collection
      @specs = new Jetdeck.Collections.AirframeSpecsCollection()
      @specs.airframe = this 

      ## images collection
      @images = new Jetdeck.Collections.AirframeImagesCollection()
      @images.airframe = this

      ## populate child collections from data loaded with page
      @updateChildren()
        
    updateChildren : =>
      @leads.reset @get("leads")
      @todos.reset @get("todos")
      @specs.reset @get("specs")
      @images.reset @get("images")
  
class Jetdeck.Collections.AirframesCollection extends Backbone.CollectionBook
  
    model: Jetdeck.Models.AirframeModel
    
    url: "/airframes"
    
    initialize: ->
      @order = "year"
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

    
