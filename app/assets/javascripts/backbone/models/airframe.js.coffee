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
    @equipment = new Jetdeck.Collections.EquipmentCollection()
    @equipment.airframe = this
    @updateEquipment
    @on('change', @updateEquipment)
    
  updateEquipment : =>
    @equipment.reset @get('equipment')
      
class Jetdeck.Collections.AirframesCollection extends Backbone.Collection
  model: Jetdeck.Models.Airframe
  url: '/airframes'
