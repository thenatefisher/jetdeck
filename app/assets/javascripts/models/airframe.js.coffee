class Jetdeck.Models.Airframe extends Backbone.Model
    paramRoot : 'airframe'

    defaults :
      serial: null
      registration: null
      year: ""
      listed: false
      damage: false
      tags: []
      location: null
      make: ""
      model_name: ""
      asking_price: 0
      description: ""
      avatar: null
      airframe_texts: []

    initialize : =>
      ## leads collection
      @leads = new Jetdeck.Collections.LeadsCollection(page_size: 5)
      @leads.airframe = this
      
      ## equipment collection
      @equipment = new Jetdeck.Collections.EquipmentCollection()
      @equipment.airframe = this
      
      ## engines collection
      @engines = new Jetdeck.Collections.EnginesCollection()
      @engines.airframe = this
      
      ## actions collection
      @actions = new Jetdeck.Collections.ActionsCollection()
      @actions.contact = this         

      ## populate child collections
      @updateChildren()
        
    updateChildren : =>
      @leads.reset @get('leads')
      @equipment.reset @get('equipment')
      @engines.reset @get('engines')
      @actions.reset @get('actions')
  
class Jetdeck.Collections.AirframesCollection extends Backbone.CollectionBook
  
    model: Jetdeck.Models.Airframe
    
    url: '/airframes'
    
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

    
