class Jetdeck.Models.Airframe extends Backbone.Model
  paramRoot : 'airframe'

  defaults :
    serial: null
    registration: null
    year: null
    listed: false
    damage: false
    tags: []
    location: null
    string: null
    headline: ""
    make: ""
    modelName: ""
    askingPrice: 0
    description: ""

  initialize : () =>
    ## leads collection
    @leads = new Jetdeck.Collections.LeadsCollection(page_size: 5)
    @leads.airframe = this
    @updateLeads()
    @on('change', @updateLeads)

    ## equipment collection
    @equipment = new Jetdeck.Collections.EquipmentCollection()
    @equipment.airframe = this
    @updateEquipment()
    @on('change', @updateEquipment)

    ## engines collection
    @engines = new Jetdeck.Collections.EnginesCollection()
    @engines.airframe = this
    @updateEngines()
    @on('change', @updateEngines)

  updateEngines : =>
    @engines.reset @get('engines')

  updateEquipment : =>
    @equipment.reset @get('equipment')

  updateLeads : =>
    @leads.reset @get('leads')

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

    
