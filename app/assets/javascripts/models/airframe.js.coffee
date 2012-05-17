class Jetdeck.Models.Airframe extends Backbone.Model
  paramRoot : 'airframe'

  defaults :
    serial: null
    registration: null
    year: null
    listed: false
    damage: false
    tags: []
    location: false

  initialize : () =>
    ## leads collection
    @leads = new Jetdeck.Collections.LeadsCollection()
    @leads.airframe = this
    @updateLeads()
    @on('change', @updateLeads)

    ## equipment collection
    @equipment = new Jetdeck.Collections.EquipmentCollection()
    @equipment.airframe = this
    @updateEquipment()
    @on('change', @updateEquipment)

  updateEquipment : =>
    @equipment.reset @get('equipment')

  updateLeads : =>
    @leads.reset @get('leads')

class Jetdeck.Collections.AirframesCollection extends Backbone.Collection
  model: Jetdeck.Models.Airframe
  url: '/airframes'
